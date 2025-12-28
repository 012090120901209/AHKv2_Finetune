#Requires AutoHotkey v2.1-alpha.17

/**
 * Module Tier 1 Example 03: Data Structures Module
 * 
 * This example demonstrates:
 * - Exporting classes from modules
 * - Class constructors in modules
 * - Instance methods in exported classes
 * - Encapsulation with classes
 * 
 * @module DataStructures
 */

#Module DataStructures

/**
 * Stack data structure (LIFO - Last In, First Out)
 * @class Stack
 */
Export class Stack {
    items := []

    /**
     * Add item to top of stack
     * @param value {Any} - Value to push
     */
    Push(value) {
        this.items.Push(value)
    }

    /**
     * Remove and return item from top of stack
     * @returns {Any} - Top item
     * @throws {Error} - If stack is empty
     */
    Pop() {
        if this.IsEmpty()
            throw Error("Stack is empty")
        return this.items.Pop()
    }

    /**
     * View top item without removing
     * @returns {Any} - Top item
     * @throws {Error} - If stack is empty
     */
    Peek() {
        if this.IsEmpty()
            throw Error("Stack is empty")
        return this.items[this.items.Length]
    }

    /**
     * Check if stack is empty
     * @returns {Boolean} - True if empty
     */
    IsEmpty() {
        return this.items.Length = 0
    }

    /**
     * Get stack size
     * @returns {Number} - Number of items
     */
    Size() {
        return this.items.Length
    }

    /**
     * Clear all items
     */
    Clear() {
        this.items := []
    }

    /**
     * Get all items as array (for debugging)
     * @returns {Array} - Copy of items
     */
    ToArray() {
        return this.items.Clone()
    }
}

/**
 * Queue data structure (FIFO - First In, First Out)
 * @class Queue
 */
Export class Queue {
    items := []

    /**
     * Add item to end of queue
     * @param value {Any} - Value to enqueue
     */
    Enqueue(value) {
        this.items.Push(value)
    }

    /**
     * Remove and return item from front of queue
     * @returns {Any} - Front item
     * @throws {Error} - If queue is empty
     */
    Dequeue() {
        if this.IsEmpty()
            throw Error("Queue is empty")
        return this.items.RemoveAt(1)
    }

    /**
     * View front item without removing
     * @returns {Any} - Front item
     * @throws {Error} - If queue is empty
     */
    Peek() {
        if this.IsEmpty()
            throw Error("Queue is empty")
        return this.items[1]
    }

    /**
     * Check if queue is empty
     * @returns {Boolean} - True if empty
     */
    IsEmpty() {
        return this.items.Length = 0
    }

    /**
     * Get queue size
     * @returns {Number} - Number of items
     */
    Size() {
        return this.items.Length
    }

    /**
     * Clear all items
     */
    Clear() {
        this.items := []
    }

    /**
     * Get all items as array (for debugging)
     * @returns {Array} - Copy of items
     */
    ToArray() {
        return this.items.Clone()
    }
}

/**
 * Simple key-value cache with size limit
 * @class Cache
 */
Export class Cache {
    data := Map()
    maxSize := 100

    /**
     * Create cache with optional size limit
     * @param maxSize {Number} - Maximum entries (default: 100)
     */
    __New(maxSize := 100) {
        this.maxSize := maxSize
    }

    /**
     * Store value in cache
     * @param key {String} - Cache key
     * @param value {Any} - Value to store
     */
    Set(key, value) {
        ; If at capacity, remove oldest (first) entry
        if this.data.Count >= this.maxSize && !this.data.Has(key) {
            for k in this.data {
                this.data.Delete(k)
                break
            }
        }

        this.data[key] := value
    }

    /**
     * Retrieve value from cache
     * @param key {String} - Cache key
     * @param default {Any} - Default if not found
     * @returns {Any} - Cached value or default
     */
    Get(key, default := "") {
        return this.data.Has(key) ? this.data[key] : default
    }

    /**
     * Check if key exists in cache
     * @param key {String} - Cache key
     * @returns {Boolean} - True if exists
     */
    Has(key) {
        return this.data.Has(key)
    }

    /**
     * Remove key from cache
     * @param key {String} - Cache key
     * @returns {Boolean} - True if removed
     */
    Delete(key) {
        if this.data.Has(key) {
            this.data.Delete(key)
            return true
        }
        return false
    }

    /**
     * Clear all cached data
     */
    Clear() {
        this.data := Map()
    }

    /**
     * Get cache size
     * @returns {Number} - Number of entries
     */
    Size() {
        return this.data.Count
    }
}

/**
 * Simple counter class
 * @class Counter
 */
Export class Counter {
    count := 0

    /**
     * Create counter with initial value
     * @param initial {Number} - Initial count (default: 0)
     */
    __New(initial := 0) {
        this.count := initial
    }

    /**
     * Increment counter
     * @param amount {Number} - Amount to increment (default: 1)
     * @returns {Number} - New count
     */
    Increment(amount := 1) {
        this.count += amount
        return this.count
    }

    /**
     * Decrement counter
     * @param amount {Number} - Amount to decrement (default: 1)
     * @returns {Number} - New count
     */
    Decrement(amount := 1) {
        this.count -= amount
        return this.count
    }

    /**
     * Reset counter to zero
     */
    Reset() {
        this.count := 0
    }

    /**
     * Get current count
     * @returns {Number} - Current count
     */
    Value() {
        return this.count
    }
}
