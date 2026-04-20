import Foundation
import Shared

enum PriorityPickerMapper {
    static func screenState(rawValue: Int32) -> PriorityScreenState {
        let priority = DemoPriority.companion.fromRaw(raw: rawValue)
        let summary = "Current: \(priority.label) (raw \(rawValue))"
        let footnote = "fromRaw(999) → \(DemoPriority.companion.fromRaw(raw: 999).label)"
        let isUnknown = priority.rawValue == DemoPriority.unknown.rawValue
        return PriorityScreenState(
            summaryLine: summary,
            footnoteUnknownExample: footnote,
            isFallbackUnknown: isUnknown
        )
    }
}
