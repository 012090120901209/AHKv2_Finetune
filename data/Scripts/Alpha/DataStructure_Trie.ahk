#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Trie - Prefix tree for efficient string operations
; Demonstrates autocomplete and word search functionality

class Trie {
    __New() {
        this.children := Map()
        this.isEnd := false
        this.count := 0
    }

    Insert(word) {
        node := this
        Loop StrLen(word) {
            char := SubStr(word, A_Index, 1)
            if !node.children.Has(char)
                node.children[char] := Trie()
            node := node.children[char]
        }
        node.isEnd := true
        node.count++
    }

    Search(word) {
        node := this.FindNode(word)
        return node && node.isEnd
    }

    StartsWith(prefix) => this.FindNode(prefix) != ""

    FindNode(str) {
        node := this
        Loop StrLen(str) {
            char := SubStr(str, A_Index, 1)
            if !node.children.Has(char)
                return ""
            node := node.children[char]
        }
        return node
    }

    ; Get all words with given prefix (autocomplete)
    GetWordsWithPrefix(prefix) {
        node := this.FindNode(prefix)
        if !node
            return []

        results := []
        this.CollectWords(node, prefix, results)
        return results
    }

    CollectWords(node, prefix, results) {
        if node.isEnd
            results.Push(prefix)

        for char, childNode in node.children
            this.CollectWords(childNode, prefix char, results)
    }
}

; Demo
myTrie := Trie()

; Insert words
words := ["apple", "application", "apply", "apt", "banana", "band", "bandana"]
for word in words
    myTrie.Insert(word)

; Search
MsgBox("Search 'apple': " myTrie.Search("apple") "`n"
    . "Search 'app': " myTrie.Search("app") "`n"
    . "StartsWith 'app': " myTrie.StartsWith("app"))

; Autocomplete
suggestions := trie.GetWordsWithPrefix("app")
result := "Autocomplete for 'app':`n"
for word in suggestions
    result .= "- " word "`n"

MsgBox(result)
result .= "- " word "`n"

MsgBox(result)
