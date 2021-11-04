import UIKit

class PagingFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let cvBounds = collectionView.bounds
        let halfWidth = cvBounds.size.width/2
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
        
        if let attributesForVisibleCells = layoutAttributesForElements(in: cvBounds) {
            
            var candidateAttributes: UICollectionViewLayoutAttributes?
            for attributes in attributesForVisibleCells {
                if let candAttrs = candidateAttributes {
                    let a = attributes.center.x - proposedContentOffsetCenterX
                    let b = candAttrs.center.x - proposedContentOffsetCenterX
                    
                    if fabsf(Float(a)) < fabsf(Float(b)) {
                        candidateAttributes = attributes
                    }
                } else {
                    candidateAttributes = attributes
                    continue
                }
            }
            
            return CGPoint(x: candidateAttributes!.center.x - halfWidth, y: proposedContentOffset.y)
        }
        
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
}
