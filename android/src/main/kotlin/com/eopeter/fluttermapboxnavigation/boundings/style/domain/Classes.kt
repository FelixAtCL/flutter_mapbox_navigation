package com.eopeter.fluttermapboxnavigation.boundings.style.domain

/**
 * The distance on each side between rectangles, when one is contained into other.
 *
 * All fields' values are in `logical pixel` units.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class MbxEdgeInsets(
    /** Padding from the top. */
    val top: Double,
    /** Padding from the left. */
    val left: Double,
    /** Padding from the bottom. */
    val bottom: Double,
    /** Padding from the right. */
    val right: Double

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): MbxEdgeInsets {
            val top = list[0] as Double
            val left = list[1] as Double
            val bottom = list[2] as Double
            val right = list[3] as Double
            return MbxEdgeInsets(top, left, bottom, right)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            top,
            left,
            bottom,
            right,
        )
    }
}

/**
 * The `transition options` controls timing for the interpolation between a transitionable style
 * property's previous value and new value. These can be used to define the style default property
 * transition behavior. Also, any transitionable style property may also have its own `-transition`
 * property that defines specific transition timing for that specific layer property, overriding
 * the global transition values.
 *
 * Generated class from Pigeon that represents data sent in messages.
 */
data class TransitionOptions(
    /** Time allotted for transitions to complete. Units in milliseconds. Defaults to `300.0`. */
    val duration: Long? = null,
    /** Length of time before a transition begins. Units in milliseconds. Defaults to `0.0`. */
    val delay: Long? = null,
    /** Whether the fade in/out symbol placement transition is enabled. Defaults to `true`. */
    val enablePlacementTransitions: Boolean? = null

) {
    companion object {
        @Suppress("UNCHECKED_CAST")
        fun fromList(list: List<Any?>): TransitionOptions {
            val duration = list[0].let { if (it is Int) it.toLong() else it as Long? }
            val delay = list[1].let { if (it is Int) it.toLong() else it as Long? }
            val enablePlacementTransitions = list[2] as Boolean?
            return TransitionOptions(duration, delay, enablePlacementTransitions)
        }
    }
    fun toList(): List<Any?> {
        return listOf<Any?>(
            duration,
            delay,
            enablePlacementTransitions,
        )
    }
}
