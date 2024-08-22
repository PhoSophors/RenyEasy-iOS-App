//
//  PhotoDetailPageViewController.swift
//  RentEasy
//
//  Created by Apple on 22/8/24.
//

import Foundation
import UIKit

class PhotoDetailPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var images: [UIImage]
    private var initialIndex: Int
    
    init(images: [UIImage], initialIndex: Int) {
        self.images = images
        self.initialIndex = initialIndex
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        view.backgroundColor = .white
        self.title = "Detail Photo"
        
        // Set the initial view controller
        if let startingViewController = viewControllerForIndex(initialIndex) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func viewControllerForIndex(_ index: Int) -> UIViewController? {
        guard index >= 0 && index < images.count else { return nil }
        let photoDetailVC = PhotoDetailViewController(image: images[index])
        photoDetailVC.currentIndex = index
        return photoDetailVC
    }
    
    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? PhotoDetailViewController else { return nil }
        var index = viewController.currentIndex
        index -= 1
        return viewControllerForIndex(index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? PhotoDetailViewController else { return nil }
        var index = viewController.currentIndex
        index += 1
        return viewControllerForIndex(index)
    }
}
