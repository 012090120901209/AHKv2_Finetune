#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Fluent HTML Builder - Chainable DOM construction
; Demonstrates builder pattern for structured output

class HtmlBuilder {
    __New(tag) {
        this.tag := tag
        this.attributes := Map()
        this.children := []
        this.text := ""
    }

    Attr(name, value) {
        this.attributes[name] := value
        return this
    }

    Class(cls) => this.Attr("class", cls)
    Id(id) => this.Attr("id", id)
    Style(style) => this.Attr("style", style)

    Data(name, value) => this.Attr("data-" name, value)

    Text(content) {
        this.text := content
        return this
    }

    Child(builder) {
        this.children.Push(builder)
        return this
    }

    Children(builders*) {
        for b in builders
            this.children.Push(b)
        return this
    }

    Build(indent := 0) {
        pad := ""
        Loop indent
            pad .= "  "

        html := pad "<" this.tag

        for name, value in this.attributes
            html .= ' ' name '="' value '"'

        if !this.children.Length && !this.text {
            html .= " />"
            return html
        }

        html .= ">"

        if this.text
            html .= this.text

        if this.children.Length {
            html .= "`n"
            for child in this.children
                html .= child.Build(indent + 1) "`n"
            html .= pad
        }

        html .= "</" this.tag ">"
        return html
    }
}

; Shorthand factory functions
H(tag) => HtmlBuilder(tag)
Div(cls := "") => cls ? H("div").Class(cls) : H("div")
Span(text := "") => text ? H("span").Text(text) : H("span")
P(text := "") => text ? H("p").Text(text) : H("p")
A(href, text) => H("a").Attr("href", href).Text(text)
Ul() => H("ul")
Li(text := "") => text ? H("li").Text(text) : H("li")
Button(text) => H("button").Text(text)

; Demo - build a card component
card := Div("card")
    .Id("user-card")
    .Style("padding: 1rem; border: 1px solid #ccc")
    .Child(
        Div("card-header")
        .Child(H("h2").Class("title").Text("John Doe"))
        .Child(Span("Premium Member").Class("badge"))
    )
    .Child(
        Div("card-body")
        .Child(P("Software Engineer at TechCorp"))
        .Child(
            Ul().Class("skills")
            .Child(Li("JavaScript"))
            .Child(Li("Python"))
            .Child(Li("AutoHotkey"))
        )
    )
    .Child(
        Div("card-footer")
        .Child(Button("Follow").Class("btn btn-primary"))
        .Child(A("mailto:john@example.com", "Contact"))
    )

MsgBox(card.Build())
