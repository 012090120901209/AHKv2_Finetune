#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Data Structure: Binary Search Tree
; Demonstrates: Tree structure, recursive operations, searching, traversals

class TreeNode {
    __New(value) => (this.value := value, this.left := "", this.right := "")
}

class BinarySearchTree {
    __New() => (this.root := "", this.size := 0)

    Insert(value) {
        this.root := this._InsertNode(this.root, value)
        return this
    }

    _InsertNode(node, value) {
        if (!node) {
            this.size++
            return TreeNode(value)
        }

        if (value < node.value)
        node.left := this._InsertNode(node.left, value)
        else if (value > node.value)
        node.right := this._InsertNode(node.right, value)

        return node
    }

    Search(value) => this._SearchNode(this.root, value)

    _SearchNode(node, value) {
        if (!node)
        return false
        if (value = node.value)
        return true
        if (value < node.value)
        return this._SearchNode(node.left, value)
        return this._SearchNode(node.right, value)
    }

    FindMin() {
        if (!this.root)
        return ""
        return this._FindMin(this.root).value
    }

    _FindMin(node) {
        while (node.left)
        node := node.left
        return node
    }

    FindMax() {
        if (!this.root)
        return ""
        return this._FindMax(this.root).value
    }

    _FindMax(node) {
        while (node.right)
        node := node.right
        return node
    }

    Delete(value) {
        this.root := this._DeleteNode(this.root, value)
        return this
    }

    _DeleteNode(node, value) {
        if (!node)
        return ""

        if (value < node.value)
        node.left := this._DeleteNode(node.left, value)
        else if (value > node.value)
        node.right := this._DeleteNode(node.right, value)
        else {
            ; Node found - delete it
            if (!node.left && !node.right) {
                this.size--
                return ""
            }
            if (!node.left) {
                this.size--
                return node.right
            }
            if (!node.right) {
                this.size--
                return node.left
            }

            ; Node has two children
            successor := this._FindMin(node.right)
            node.value := successor.value
            node.right := this._DeleteNode(node.right, successor.value)
        }

        return node
    }

    InOrder() {
        result := []
        this._InOrderTraversal(this.root, result)
        return result
    }

    _InOrderTraversal(node, result) {
        if (!node)
        return
        this._InOrderTraversal(node.left, result)
        result.Push(node.value)
        this._InOrderTraversal(node.right, result)
    }

    PreOrder() {
        result := []
        this._PreOrderTraversal(this.root, result)
        return result
    }

    _PreOrderTraversal(node, result) {
        if (!node)
        return
        result.Push(node.value)
        this._PreOrderTraversal(node.left, result)
        this._PreOrderTraversal(node.right, result)
    }

    PostOrder() {
        result := []
        this._PostOrderTraversal(this.root, result)
        return result
    }

    _PostOrderTraversal(node, result) {
        if (!node)
        return
        this._PostOrderTraversal(node.left, result)
        this._PostOrderTraversal(node.right, result)
        result.Push(node.value)
    }

    GetHeight() => this._GetHeight(this.root)

    _GetHeight(node) {
        if (!node)
        return -1
        return 1 + Max(this._GetHeight(node.left), this._GetHeight(node.right))
    }

    ToString() => "InOrder: [" . this.InOrder().Join(", ") . "] | Size: " . this.size . " | Height: " . this.GetHeight()
}

; Usage
bst := BinarySearchTree()

; Insert values
bst.Insert(50).Insert(30).Insert(70).Insert(20).Insert(40).Insert(60).Insert(80)
MsgBox("BST: " . bst.ToString())

; Traversals
MsgBox("InOrder: " . bst.InOrder().Join(", ") . "`nPreOrder: " . bst.PreOrder().Join(", ") . "`nPostOrder: " . bst.PostOrder().Join(", "))

; Search
MsgBox("Search 40: " . (bst.Search(40) ? "Found" : "Not found"))
MsgBox("Search 100: " . (bst.Search(100) ? "Found" : "Not found"))

; Min/Max
MsgBox("Min: " . bst.FindMin() . "`nMax: " . bst.FindMax())

; Delete
bst.Delete(30)
MsgBox("After deleting 30: " . bst.ToString())

bst.Delete(50)
MsgBox("After deleting root (50): " . bst.ToString())
