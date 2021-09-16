import Foundation

public extension XCUIElement {

    internal static var currentRoot: XCUIElement = XCPlusApp.activeApplication()

    internal func queryWith(classChainItem item: ClassChainItem, query: XCUIElementQuery?) -> XCUIElementQuery {
        var query = query

        if item.isDescendant {
            if query != nil {
                query = query?.descendants(matching: item.type)
            } else {
                query = self.descendants(matching: item.type)
            }
        } else {
            if query != nil {
                query = query?.children(matching: item.type)
            } else {
                query = self.children(matching: item.type)
            }
        }

        if let predicate = item.predicates {
            query = query?.matching(predicate)
        }
        guard let newQuery = query else {
            AssertFail(message: INVALID_CHASS_CHAIN_QUERY)
            return self.children(matching: item.type)
        }
        return newQuery
    }
}
