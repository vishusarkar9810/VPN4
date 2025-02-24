import Foundation
import UIKit

public extension TagsFlowLayout {
    
    enum LayoutAlignment: Int {
        case left
        case center
        case right
    }
}

public class TagsFlowLayout: UICollectionViewFlowLayout {
    
    let alignment: LayoutAlignment
    
    //MARK: - Init Methods
    
    required init(alignment: LayoutAlignment = .left, minimumInteritemSpacing: CGFloat = 5, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.alignment = alignment
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        
        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        if #available(iOS 11.0, *) {
            self.sectionInsetReference = SectionInsetReference.fromContentInset
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superArray = super.layoutAttributesForElements(in: rect) else {  return nil  }
        guard let attributes = NSArray(array: superArray, copyItems: true) as? [UICollectionViewLayoutAttributes] else {  return nil  }
        // Constants
        let leftPadding: CGFloat = 0
        let interItemSpacing = minimumInteritemSpacing
        // Tracking values
        var leftMargin: CGFloat = leftPadding // Modified to determine origin.x for each item
        var maxY: CGFloat = -1.0 // Modified to determine origin.y for each item
        var rowSizes: [[CGFloat]] = [] // Tracks the starting and ending x-values for the first and last item in the row
        var currentRow: Int = 0 // Tracks the current row
        attributes.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            // Each layoutAttribute represents its own item
            if layoutAttribute.frame.origin.y >= maxY {
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                // Register its origin.x in rowSizes for use later
                if rowSizes.count == 0 {
                    // Add to first row
                    rowSizes = [[leftMargin, 0]]
                } else {
                    // Append a new row
                    rowSizes.append([leftMargin, 0])
                    currentRow += 1
                }
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
            // Add right-most x value for last item in the row
            rowSizes[currentRow][1] = leftMargin - interItemSpacing
        }
        
        guard alignment != .left && alignment != .right else {
            return attributes
        }
        
        // At this point, all cells are left aligned
        // Reset tracking values and add extra left padding to center align entire row
        leftMargin = leftPadding
        maxY = -1.0
        currentRow = 0
        attributes.forEach { layoutAttribute in
            // Each layoutAttribute is its own item
            if layoutAttribute.frame.origin.y >= maxY {
                // This layoutAttribute represents the left-most item in the row
                leftMargin = leftPadding
                // Need to bump it up by an appended margin
                let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0] // last.x - first.x
                let appendedMargin = (collectionView!.frame.width - leftPadding  - rowWidth - leftPadding) / 2
                leftMargin += appendedMargin
                currentRow += 1
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + interItemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
    
    public override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }
    
    public override var developmentLayoutDirection: UIUserInterfaceLayoutDirection {
        if alignment == .right {
            return UIUserInterfaceLayoutDirection.rightToLeft
        } else {
            return UIUserInterfaceLayoutDirection.leftToRight
        }
    }
}

