#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Binary Search Tree - Ordered collection with O(log n) operations
; Demonstrates insertion, search, and traversal

class BSTNode {
    __New(value) {
        this.value := value
        this.left := ""
        this.right := ""
    }
}

class BST {
    __New() => this.root := ""

    Insert(value) {
        if !this.root {
            this.root := BSTNode(value)
            return
        }
        this.InsertNode(this.root, value)
    }

    InsertNode(node, value) {
        if value < node.value {
            if !node.left
                node.left := BSTNode(value)
            else
                this.InsertNode(node.left, value)
        } else {
            if !node.right
                node.right := BSTNode(value)
            else
                this.InsertNode(node.right, value)
        }
    }

    Search(value) => this.SearchNode(this.root, value)

    SearchNode(node, value) {
        if !node
            return false
        if value = node.value
            return true
        if value < node.value
            return this.SearchNode(node.left, value)
        return this.SearchNode(node.right, value)
    }

    ; Traversal methods
    InOrder() {
        result := []
        this.InOrderTraverse(this.root, result)
        return result
    }

    InOrderTraverse(node, result) {
        if !node
            return
        this.InOrderTraverse(node.left, result)
        result.Push(node.value)
        this.InOrderTraverse(node.right, result)
    }

    PreOrder() {
        result := []
        this.PreOrderTraverse(this.root, result)
        return result
    }

    PreOrderTraverse(node, result) {
        if !node
            return
        result.Push(node.value)
        this.PreOrderTraverse(node.left, result)
        this.PreOrderTraverse(node.right, result)
    }

    Min() {
        if !this.root
            return ""
        node := this.root
        while node.left
            node := node.left
        return node.value
    }

    Max() {
        if !this.root
            return ""
        node := this.root
        while node.right
            node := node.right
        return node.value
    }
}

; Demo
myBST := BST()
values := [50, 30, 70, 20, 40, 60, 80]

for v in values
    myBST.Insert(v)

inorder := myBST.InOrder()
result := "In-order (sorted): "
for v in inorder
    result .= v " "

result .= "`n`nMin: " bst.Min()
result .= "`nMax: " bst.Max()
result .= "`n`nSearch 40: " bst.Search(40)
result .= "`nSearch 99: " bst.Search(99)

MsgBox(result)
