import Foundation

// MARK: - Assertion Messages
let messages = ["element.present.pass": "Expected %@ should be present; Actual %@ is present",
                "element.present.fail": "Expected %@ should be present; Actual %@ is not present",
                "element.notpresent.pass": "Expected %@ should not be present; Actual %@ is not present",
                "element.notpresent.fail": "Expected %@ should not be present; Actual %@ is present",
                "element.visible.pass": "Expected %@ should be visible; Actual %@ is visible",
                "element.visible.fail": "Expected %@ should be visible; Actual %@ is not visible",
                "element.notvisible.pass": "Expected %@ should not be visible; Actual %@ is not visible",
                "element.notvisible.fail": "Expected %@ should not be visible; Actual %@ is visible",
                "element.disabled.pass": "Expected %@ should be disabled; Actual %@ is disabled",
                "element.disabled.fail": "Expected %@ should be disabled; Actual %@ is not disabled",
                "element.enabled.pass": "Expected %@ should be enable; Actual %@ is enabled",
                "element.enabled.fail": "Expected %@ should be enable; Actual %@ is not enabled",
                "element.notenabled.pass": "Expected %@ should not be enable; Actual %@ is not enabled",
                "element.notenabled.fail": "Expected %@ should not be enable; Actual %@ is enabled",
                "element.selected.pass": "Expected %@ should be selected; Actual %@ is selected",
                "element.selected.fail": "Expected %@ should be selected; Actual %@ is not selected",
                "element.notselected.pass": "Expected %@ should not be selected; Actual %@ is not selected",
                "element.notselected.fail": "Expected %@ should not be selected; Actual %@ is selected",
                "element.labeled.pass": "Expected %@ label should be %@; Actual %@ label is %@",
                "element.labeled.fail": "Expected %@ label should be %@; Actual %@ label is not %@",
                "element.notlabeled.pass": "Expected %@ label should not %@; Actual %@ label is not %@",
                "element.notlabeled.fail": "Expected %@ label should not %@; Actual %@ label is %@",
                "element.value.pass": "Expected %@ value should be %@; Actual %@ value is %@",
                "element.value.fail": "Expected %@ value should be %@; Actual %@ value is not %@",
                "element.notvalue.pass": "Expected %@ value should not %@; Actual %@ value is not %@",
                "element.notvalue.fail": "Expected %@ value should not %@; Actual %@ value is %@"]

// MARK: - Error Messages
let NOT_YET_IMPLEMENTED = "Not Yet Implemented: %@"
let INVALID_ARGUMENT_FOR_CLASS = "Invalid argument for class used %@. Did you mean XCUIElementType %@?"
let INVALID_CHASS_CHAIN_QUERY = "Invalid Chass Chain Query: %@"
