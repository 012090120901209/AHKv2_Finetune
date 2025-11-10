#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * CLR - XML Processing
 *
 * Demonstrates using .NET System.Xml for parsing, creating, and
 * manipulating XML documents with XPath queries.
 *
 * Library: https://github.com/Lexikos/CLR.ahk
 */

MsgBox("CLR - XML Processing Example`n`n"
     . "Demonstrates .NET XML APIs`n"
     . "Requires: CLR.ahk and .NET Framework 4.0+", , "T3")

/*
; Uncomment to run (requires CLR.ahk):

#Include <CLR>

; Initialize CLR
CLR_Start("v4.0.30319")

; Compile XML helper
xmlCode := "
(
using System;
using System.Xml;
using System.Text;

public class XmlHelper {
    public static string CreateXmlDocument() {
        XmlDocument doc = new XmlDocument();

        // XML declaration
        XmlDeclaration declaration = doc.CreateXmlDeclaration(""1.0"", ""UTF-8"", null);
        doc.AppendChild(declaration);

        // Root element
        XmlElement root = doc.CreateElement(""catalog"");
        doc.AppendChild(root);

        // Add books
        AddBook(doc, root, ""1"", ""XML Developer's Guide"", ""Gambardella, Matthew"", ""2000"", ""44.95"");
        AddBook(doc, root, ""2"", ""Midnight Rain"", ""Ralls, Kim"", ""2000"", ""5.95"");
        AddBook(doc, root, ""3"", ""The Sundered Grail"", ""Corets, Eva"", ""2001"", ""5.95"");

        return doc.OuterXml;
    }

    private static void AddBook(XmlDocument doc, XmlElement parent, string id,
                                string title, string author, string year, string price) {
        XmlElement book = doc.CreateElement(""book"");
        book.SetAttribute(""id"", id);

        XmlElement titleEl = doc.CreateElement(""title"");
        titleEl.InnerText = title;
        book.AppendChild(titleEl);

        XmlElement authorEl = doc.CreateElement(""author"");
        authorEl.InnerText = author;
        book.AppendChild(authorEl);

        XmlElement yearEl = doc.CreateElement(""year"");
        yearEl.InnerText = year;
        book.AppendChild(yearEl);

        XmlElement priceEl = doc.CreateElement(""price"");
        priceEl.InnerText = price;
        book.AppendChild(priceEl);

        parent.AppendChild(book);
    }

    public static string ParseXml(string xml) {
        XmlDocument doc = new XmlDocument();
        doc.LoadXml(xml);

        StringBuilder result = new StringBuilder();
        XmlNodeList books = doc.SelectNodes(""//book"");

        foreach (XmlNode book in books) {
            string id = book.Attributes[""id""].Value;
            string title = book.SelectSingleNode(""title"").InnerText;
            string author = book.SelectSingleNode(""author"").InnerText;
            string price = book.SelectSingleNode(""price"").InnerText;

            result.AppendLine($""Book {id}: {title} by {author} (${price})"");
        }

        return result.ToString();
    }

    public static string SearchByAuthor(string xml, string authorName) {
        XmlDocument doc = new XmlDocument();
        doc.LoadXml(xml);

        StringBuilder result = new StringBuilder();
        XmlNodeList books = doc.SelectNodes(""//book[contains(author, '"" + authorName + ""')]"");

        foreach (XmlNode book in books) {
            string title = book.SelectSingleNode(""title"").InnerText;
            result.AppendLine(title);
        }

        return result.ToString();
    }

    public static string GetBooksAfterYear(string xml, int year) {
        XmlDocument doc = new XmlDocument();
        doc.LoadXml(xml);

        StringBuilder result = new StringBuilder();
        XmlNodeList books = doc.SelectNodes(""//book[year>"" + year + ""]"");

        foreach (XmlNode book in books) {
            string title = book.SelectSingleNode(""title"").InnerText;
            string bookYear = book.SelectSingleNode(""year"").InnerText;
            result.AppendLine($""{title} ({bookYear})"");
        }

        return result.ToString();
    }

    public static string FormatXml(string xml) {
        XmlDocument doc = new XmlDocument();
        doc.LoadXml(xml);

        StringBuilder sb = new StringBuilder();
        XmlWriterSettings settings = new XmlWriterSettings {
            Indent = true,
            IndentChars = ""  "",
            NewLineChars = ""\n"",
            NewLineHandling = NewLineHandling.Replace
        };

        using (XmlWriter writer = XmlWriter.Create(sb, settings)) {
            doc.Save(writer);
        }

        return sb.ToString();
    }
}
)"

refs := "System.dll|System.Xml.dll"
asm := CLR_CompileCS(xmlCode, refs)
Xml := asm.GetType("XmlHelper")

; Example 1: Create XML document
MsgBox("Example 1: Creating XML document...", , "T2")

xmlDoc := Xml.CreateXmlDocument()
MsgBox("Created XML (first 200 chars):`n`n" SubStr(xmlDoc, 1, 200) "...", , "T5")

; Example 2: Parse and display XML
MsgBox("Example 2: Parsing XML...", , "T2")

parsed := Xml.ParseXml(xmlDoc)
MsgBox("Parsed Books:`n`n" parsed, , "T5")

; Example 3: Search by author
MsgBox("Example 3: Searching by author...", , "T2")

results := Xml.SearchByAuthor(xmlDoc, "Corets")
if (results != "")
    MsgBox("Books by 'Corets':`n`n" results, , "T3")
else
    MsgBox("No books found", , "T2")

; Example 4: Filter by year
MsgBox("Example 4: Books after year 2000...", , "T2")

filtered := Xml.GetBooksAfterYear(xmlDoc, 2000)
if (filtered != "")
    MsgBox("Books after 2000:`n`n" filtered, , "T3")

; Example 5: Format XML (pretty print)
MsgBox("Example 5: Formatted XML...", , "T2")

formatted := Xml.FormatXml(xmlDoc)
MsgBox("Formatted XML:`n`n" SubStr(formatted, 1, 300) "...", , "T5")

MsgBox("XML processing example completed!", , "T2")
*/

/*
 * Key Concepts:
 *
 * 1. XmlDocument:
 *    Main XML document object
 *    LoadXml(string) - Parse XML
 *    Load(path) - Load from file
 *    Save(path) - Save to file
 *
 * 2. Creating Elements:
 *    CreateElement(name) - New element
 *    CreateAttribute(name) - New attribute
 *    AppendChild(node) - Add child
 *    SetAttribute(name, value) - Set attr
 *
 * 3. XPath Queries:
 *    SelectNodes(xpath) - Multiple nodes
 *    SelectSingleNode(xpath) - First match
 *    Powerful query language
 *
 * 4. Common XPath:
 *    //element - All matching elements
 *    /root/child - Direct child
 *    //[@attr='value'] - By attribute
 *    //[contains(text(),'str')] - By text
 *
 * 5. Node Properties:
 *    InnerText - Text content
 *    InnerXml - XML content
 *    OuterXml - Full XML with element
 *    Attributes - Attribute collection
 *
 * 6. XmlWriter:
 *    For creating formatted XML
 *    Control indentation
 *    Streaming API
 *
 * 7. XmlReader:
 *    Fast, forward-only reading
 *    Low memory footprint
 *    Good for large files
 *
 * 8. Use Cases:
 *    ✅ Configuration files
 *    ✅ Data exchange
 *    ✅ SOAP web services
 *    ✅ SVG manipulation
 *    ✅ Office document formats
 *
 * 9. Advantages:
 *    ✅ Powerful XPath
 *    ✅ DOM manipulation
 *    ✅ Schema validation
 *    ✅ XSLT transforms
 *
 * 10. Best Practices:
 *     ✅ Validate XML structure
 *     ✅ Use XPath for queries
 *     ✅ Handle encoding properly
 *     ✅ Use XmlWriter for creation
 *     ✅ Consider XDocument (LINQ)
 *
 * 11. XPath Examples:
 *     //book - All book elements
 *     //book[@id='1'] - Book with id 1
 *     //book/title - All titles
 *     //book[price<10] - Books under $10
 *     //book[position()=1] - First book
 *
 * 12. Performance Notes:
 *     XmlDocument - Full DOM, memory
 *     XmlReader - Streaming, fast
 *     XDocument (LINQ) - Modern API
 *     Choose based on needs
 */
