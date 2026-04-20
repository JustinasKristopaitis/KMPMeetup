package com.justinaskristopaitis.kmpmeetup

/**
 * Enum exported to ObjC/Swift without Skie conveniences.
 * Unknown numeric values map to [UNKNOWN] so Swift can always show a safe default.
 */
enum class DemoPriority(val rawValue: Int, val label: String) {
    LOW(0, "Low"),
    MEDIUM(1, "Medium"),
    HIGH(2, "High"),
    UNKNOWN(-1, "Unknown (default)"),
    ;

    companion object {
        fun fromRaw(raw: Int): DemoPriority = when (raw) {
            LOW.rawValue -> LOW
            MEDIUM.rawValue -> MEDIUM
            HIGH.rawValue -> HIGH
            else -> UNKNOWN
        }
    }
}
