#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Data Structure: Trie (Prefix Tree)
; Demonstrates: String storage, prefix search, autocomplete

class TrieNode {
    __New() => (this.children := Map(), this.isEndOfWord := false)
}

class Trie {
    __New() => this.root := TrieNode()

    Insert(word) {
        node := this.root

        loop parse word {
            char := A_LoopField

            if (!node.children.Has(char))
                node.children[char] := TrieNode()

            node := node.children[char]
        }

        node.isEndOfWord := true
        return this
    }

    Search(word) {
        node := this._FindNode(word)
        return node && node.isEndOfWord
    }

    StartsWith(prefix) => this._FindNode(prefix) ? true : false

    _FindNode(str) {
        node := this.root

        loop parse str {
            char := A_LoopField

            if (!node.children.Has(char))
                return ""

            node := node.children[char]
        }

        return node
    }

    Delete(word) {
        if (!this.Search(word))
            return false

        this._DeleteHelper(this.root, word, 0)
        return true
    }

    _DeleteHelper(node, word, index) {
        if (index = StrLen(word)) {
            node.isEndOfWord := false
            return node.children.Count = 0
        }

        char := SubStr(word, index + 1, 1)

        if (!node.children.Has(char))
            return false

        childNode := node.children[char]
        shouldDeleteChild := this._DeleteHelper(childNode, word, index + 1)

        if (shouldDeleteChild) {
            node.children.Delete(char)
            return node.children.Count = 0 && !node.isEndOfWord
        }

        return false
    }

    GetAllWords() {
        words := []
        this._CollectWords(this.root, "", words)
        return words
    }

    _CollectWords(node, prefix, words) {
        if (node.isEndOfWord)
            words.Push(prefix)

        for char, childNode in node.children
            this._CollectWords(childNode, prefix . char, words)
    }

    GetWordsWithPrefix(prefix) {
        node := this._FindNode(prefix)
        if (!node)
            return []

        words := []
        this._CollectWords(node, prefix, words)
        return words
    }

    CountWords() {
        count := 0
        this._CountWordsHelper(this.root, &count)
        return count
    }

    _CountWordsHelper(node, &count) {
        if (node.isEndOfWord)
            count++

        for char, childNode in node.children
            this._CountWordsHelper(childNode, &count)
    }

    LongestCommonPrefix() {
        if (this.root.children.Count = 0)
            return ""

        prefix := ""
        node := this.root

        while (node.children.Count = 1 && !node.isEndOfWord) {
            for char, childNode in node.children {
                prefix .= char
                node := childNode
            }
        }

        return prefix
    }

    ToString() => "Trie with " . this.CountWords() . " words: [" . this.GetAllWords().Join(", ") . "]"
}

; Usage
trieobj := Trie()

; Insert words
trieobj .Insert("apple").Insert("app").Insert("application")
    .Insert("apply").Insert("banana").Insert("band")
    .Insert("bandana").Insert("can").Insert("candy")

MsgBox(trieobj .ToString())

; Search
MsgBox("Search 'apple': " . (trieobj .Search("apple") ? "Found" : "Not found"))
MsgBox("Search 'app': " . (trieobj .Search("app") ? "Found" : "Not found"))
MsgBox("Search 'appl': " . (trieobj .Search("appl") ? "Found" : "Not found"))

; Prefix search
MsgBox("Starts with 'app': " . (trieobj .StartsWith("app") ? "Yes" : "No"))
MsgBox("Starts with 'ban': " . (trieobj .StartsWith("ban") ? "Yes" : "No"))
MsgBox("Starts with 'xyz': " . (trieobj .StartsWith("xyz") ? "Yes" : "No"))

; Autocomplete
MsgBox("Words starting with 'app': " . trieobj .GetWordsWithPrefix("app").Join(", "))
MsgBox("Words starting with 'ban': " . trieobj .GetWordsWithPrefix("ban").Join(", "))
MsgBox("Words starting with 'c': " . trieobj .GetWordsWithPrefix("c").Join(", "))

; All words
MsgBox("All words: " . trieobj .GetAllWords().Join(", "))

; Delete
trieobj .Delete("app")
MsgBox("After deleting 'app': " . trieobj .GetAllWords().Join(", "))

; Dictionary example
dictionary := Trie()
dictionary.Insert("hello").Insert("world").Insert("help")
    .Insert("heap").Insert("house").Insert("home")

MsgBox("Dictionary autocomplete 'he': " . dictionary.GetWordsWithPrefix("he").Join(", "))
MsgBox("Dictionary autocomplete 'ho': " . dictionary.GetWordsWithPrefix("ho").Join(", "))
