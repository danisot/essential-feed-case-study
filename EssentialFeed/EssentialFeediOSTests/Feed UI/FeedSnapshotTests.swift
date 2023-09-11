//
//  FeedSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by José Daniel Fernández Sotelo on 17/8/23.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

final class FeedSnapshotTests: XCTestCase {

    func test_emptyFeed() {
        let sut = makeSUT()

        sut.display(emptyFeed())

        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "EMPTY_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "EMPTY_FEED_dark")
    }

    func test_feedWithContent() {
        let sut = makeSUT()

        sut.display(feedWithContent())

        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "FEED_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "FEED_WITH_CONTENT_dark")
    }

    func test_feedWithErrorMessage() {
        let sut = makeSUT()

        sut.display(.error(message: "This is a\nmulti-line\nerror message"))

        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "FEED_WITH_ERROR_MESSAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "FEED_WITH_ERROR_MESSAGE_dark")
    }

    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()

        sut.display(feedWithFailedImageLoading())

        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "FEED_WITH_FAILED_IMAGE_LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "FEED_WITH_FAILED_IMAGE_LOADING_dark")
    }

    // MARK: - Helpers

    private func makeSUT() -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! FeedViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func emptyFeed() -> [FeedImageCellController] {
        []
    }

    private func feedWithContent() -> [ImageStub] {
        [
            ImageStub(
                description: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                location: "East Side Gallery\nMemorial in Berlin, Germany",
                image: UIImage.make(withColor: .red)
            ),
            ImageStub(
                description: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.",
                location: "Garth Pier",
                image: UIImage.make(withColor: .green)
            )
        ]
    }

    private func feedWithFailedImageLoading() -> [ImageStub] {
        [
            ImageStub(
                description: nil,
                location: "Cannon Street, London",
                image: nil
            ),
            ImageStub(
                description: nil,
                location: "Brighton Seafront",
                image: nil
            )
        ]
    }

    private func assert(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)

        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return
        }

        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot before asserting.", file: file, line: line)
            return
        }

        if !match(snapshotData, storedSnapshotData, tolerance: 0.00005) {
            let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent(snapshotURL.lastPathComponent)

            try? snapshotData.write(to: temporarySnapshotURL)

            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL), Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }

    private func record(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)

        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return
        }

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )

            try snapshotData.write(to: snapshotURL)
            XCTFail("Record succeeded - use `assert` to compare the snapshot from now on.", file: file, line: line)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }

    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
    }

    private func match(_ oldData: Data, _ newData: Data, tolerance: Float = 0) -> Bool {
        if oldData == newData { return true }

        guard let oldImage = UIImage(data: oldData)?.cgImage, let newImage = UIImage(data: newData)?.cgImage else {
            return false
        }

        guard oldImage.width == newImage.width, oldImage.height == newImage.height else {
            return false
        }

        let minBytesPerRow = min(oldImage.bytesPerRow, newImage.bytesPerRow)
        let bytesCount = minBytesPerRow * oldImage.height

        var oldImageByteBuffer = [UInt8](repeating: 0, count: bytesCount)
        guard let oldImageData = data(for: oldImage, bytesPerRow: minBytesPerRow, buffer: &oldImageByteBuffer) else {
            return false
        }

        var newImageByteBuffer = [UInt8](repeating: 0, count: bytesCount)
        guard let newImageData = data(for: newImage, bytesPerRow: minBytesPerRow, buffer: &newImageByteBuffer) else {
            return false
        }

        if memcmp(oldImageData, newImageData, bytesCount) == 0 { return true }

        return match(oldImageByteBuffer, newImageByteBuffer, tolerance: tolerance, bytesCount: bytesCount)
    }

    private func data(for image: CGImage, bytesPerRow: Int, buffer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
        guard
            let space = image.colorSpace,
            let context = CGContext(
                data: buffer,
                width: image.width,
                height: image.height,
                bitsPerComponent: image.bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: space,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )
        else { return nil }

        context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))

        return context.data
    }

    private func match(_ bytes1: [UInt8], _ bytes2: [UInt8], tolerance: Float, bytesCount: Int) -> Bool {
        var differentBytesCount = 0
        for i in 0 ..< bytesCount where bytes1[i] != bytes2[i] {
            differentBytesCount += 1

            let percentage = Float(differentBytesCount) / Float(bytesCount)
            if percentage > tolerance {
                return false
            }
        }
        return true
    }
}

extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}

struct SnapshotConfiguration {

    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection

    static func iPhone14(style: UIUserInterfaceStyle) -> SnapshotConfiguration {
        SnapshotConfiguration(
            size: CGSize(width: 390, height: 844),
            safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            layoutMargins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
            traitCollection: UITraitCollection(traitsFrom: [
                .init(forceTouchCapability: .available),
                .init(layoutDirection: .leftToRight),
                .init(preferredContentSizeCategory: .medium),
                .init(userInterfaceIdiom: .phone),
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(displayScale: 2),
                .init(displayGamut: .P3),
                .init(userInterfaceStyle: style)
            ]))
    }
}

private final class SnapshotWindow: UIWindow {

    private var configuration: SnapshotConfiguration = .iPhone14(style: .light)

    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        self.layoutMargins = configuration.layoutMargins
        self.rootViewController = root
        self.isHidden = false
        root.view.layoutMargins = configuration.layoutMargins
    }

    override var safeAreaInsets: UIEdgeInsets {
        configuration.safeAreaInsets
    }

    override var traitCollection: UITraitCollection {
        UITraitCollection(traitsFrom: [super.traitCollection, configuration.traitCollection])
    }

    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}

private extension FeedViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [FeedImageCellController] = stubs.map { stub in
            let cellController = FeedImageCellController(delegate: stub)
            stub.controller = cellController
            return cellController
        }

        display(cells)
    }
}

private class ImageStub: FeedImageCellControllerDelegate {

    let viewModel: FeedImageViewModel<UIImage>
    weak var controller: FeedImageCellController?

    init(description: String?, location: String?, image: UIImage?) {
        viewModel = FeedImageViewModel(
            description: description,
            location: location,
            image: image,
            isLoading: false,
            shouldRetry: image == nil)
    }

    func didRequestImage() {
        controller?.display(viewModel)
    }

    func didCancelImageRequest() {}
}
