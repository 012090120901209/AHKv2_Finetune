#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Visitor Pattern
; Demonstrates: Double dispatch, operation separation, extensibility

class Element {
    Accept(visitor) => throw Error("Must implement Accept()")
}

class ConcreteElementA extends Element {
    Accept(visitor) => visitor.VisitElementA(this)
    OperationA() => "ElementA"
}

class ConcreteElementB extends Element {
    Accept(visitor) => visitor.VisitElementB(this)
    OperationB() => "ElementB"
}

class Visitor {
    VisitElementA(element) => throw Error("Must implement VisitElementA()")
    VisitElementB(element) => throw Error("Must implement VisitElementB()")
}

class ExportVisitor extends Visitor {
    __New() => this.result := ""
    VisitElementA(element) => this.result .= "Exported: " element.OperationA() "`n"
    VisitElementB(element) => this.result .= "Exported: " element.OperationB() "`n"
    GetResult() => this.result
}

class RenderVisitor extends Visitor {
    __New() => this.result := ""
    VisitElementA(element) => this.result .= "Rendered: " element.OperationA() " (style A)`n"
    VisitElementB(element) => this.result .= "Rendered: " element.OperationB() " (style B)`n"
    GetResult() => this.result
}

; Usage
elements := [ConcreteElementA(), ConcreteElementB()]

exportVisitor := ExportVisitor()
for element in elements
element.Accept(exportVisitor)
MsgBox(exportVisitor.GetResult())

renderVisitor := RenderVisitor()
for element in elements
element.Accept(renderVisitor)
MsgBox(renderVisitor.GetResult())
