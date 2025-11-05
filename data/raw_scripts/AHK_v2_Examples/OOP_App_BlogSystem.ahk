#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Real-world OOP Application: Blog System
; Demonstrates: Content management, comments, authors, categories, tags

class Author {
    static nextAuthorId := 1

    __New(username, email, displayName) {
        this.authorId := Author.nextAuthorId++
        this.username := username
        this.email := email
        this.displayName := displayName
        this.bio := ""
        this.posts := []
        this.joinedDate := A_Now
    }

    SetBio(bio) => (this.bio := bio, this)
    GetPostCount() => this.posts.Length
    ToString() => Format("@{1} ({2}) - {3} posts", this.username, this.displayName, this.posts.Length)
}

class Comment {
    static nextCommentId := 1

    __New(author, content) {
        this.commentId := Comment.nextCommentId++
        this.author := author
        this.content := content
        this.createdAt := A_Now
        this.replies := []
    }

    AddReply(comment) => (this.replies.Push(comment), this)

    ToString() => Format("[{1}] {2}: {3}{4}",
        FormatTime(this.createdAt, "MM/dd HH:mm"),
        this.author.displayName,
        this.content,
        this.replies.Length > 0 ? " (" . this.replies.Length . " replies)" : "")
}

class Post {
    static nextPostId := 1
    static STATUS_DRAFT := "DRAFT"
    static STATUS_PUBLISHED := "PUBLISHED"
    static STATUS_ARCHIVED := "ARCHIVED"

    __New(author, title, content) {
        this.postId := Post.nextPostId++
        this.author := author
        this.title := title
        this.content := content
        this.status := Post.STATUS_DRAFT
        this.categories := []
        this.tags := []
        this.comments := []
        this.views := 0
        this.createdAt := A_Now
        this.publishedAt := ""
        this.updatedAt := A_Now
        author.posts.Push(this)
    }

    AddCategory(category) => (this.categories.Push(category), this)
    AddTag(tag) => (this.tags.Push(tag), this)

    Publish() {
        this.status := Post.STATUS_PUBLISHED
        this.publishedAt := A_Now
        MsgBox(Format("Post published: {1}", this.title))
        return this
    }

    Archive() => (this.status := Post.STATUS_ARCHIVED, this)

    Update(content) {
        this.content := content
        this.updatedAt := A_Now
        MsgBox("Post updated!")
        return this
    }

    AddComment(author, content) {
        comment := Comment(author, content)
        this.comments.Push(comment)
        return comment
    }

    IncrementViews() => (this.views++, this)

    GetExcerpt(length := 100) {
        excerpt := this.content
        if (StrLen(excerpt) > length)
            excerpt := SubStr(excerpt, 1, length) . "..."
        return excerpt
    }

    ToString() {
        post := Format("[{1}] {2}`n", this.status, this.title)
        post .= Format("By: {1} | {2}`n", this.author.displayName, FormatTime(this.createdAt, "yyyy-MM-dd"))
        post .= Format("Views: {1} | Comments: {2}`n", this.views, this.comments.Length)
        if (this.categories.Length > 0)
            post .= "Categories: " . this.categories.Join(", ") . "`n"
        if (this.tags.Length > 0)
            post .= "Tags: " . this.tags.Join(", ") . "`n"
        post .= "`n" . this.GetExcerpt(150)
        return post
    }
}

class Blog {
    __New(name, description) => (this.name := name, this.description := description, this.posts := [], this.authors := Map())

    RegisterAuthor(author) => (this.authors[author.authorId] := author, author)

    CreatePost(author, title, content) {
        if (!this.authors.Has(author.authorId))
            return MsgBox("Author not registered!", "Error")

        post := Post(author, title, content)
        this.posts.Push(post)
        return post
    }

    GetPublishedPosts() {
        published := []
        for post in this.posts
            if (post.status = Post.STATUS_PUBLISHED)
                published.Push(post)
        return published
    }

    GetPostsByAuthor(authorId) {
        filtered := []
        for post in this.posts
            if (post.author.authorId = authorId)
                filtered.Push(post)
        return filtered
    }

    GetPostsByCategory(category) {
        filtered := []
        for post in this.posts
            for cat in post.categories
                if (cat = category)
                    filtered.Push(post)
        return filtered
    }

    GetPostsByTag(tag) {
        filtered := []
        for post in this.posts
            for t in post.tags
                if (t = tag)
                    filtered.Push(post)
        return filtered
    }

    SearchPosts(query) {
        results := []
        for post in this.posts
            if (InStr(post.title, query) || InStr(post.content, query))
                results.Push(post)
        return results
    }

    GetPopularPosts(limit := 5) {
        ; Simple bubble sort by views
        sorted := this.GetPublishedPosts().Clone()
        n := sorted.Length
        loop n - 1 {
            i := A_Index
            loop n - i {
                j := A_Index
                if (sorted[j].views < sorted[j + 1].views) {
                    temp := sorted[j]
                    sorted[j] := sorted[j + 1]
                    sorted[j + 1] := temp
                }
            }
        }

        results := []
        loop Min(limit, sorted.Length)
            results.Push(sorted[A_Index])
        return results
    }

    GetBlogStats() {
        stats := this.name . " - Statistics`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        stats .= Format("Total posts: {1}`n", this.posts.Length)
        stats .= Format("Published: {1}`n", this.GetPublishedPosts().Length)
        stats .= Format("Authors: {1}`n", this.authors.Count)

        totalViews := 0
        totalComments := 0
        for post in this.posts {
            totalViews += post.views
            totalComments += post.comments.Length
        }

        stats .= Format("Total views: {1}`n", totalViews)
        stats .= Format("Total comments: {1}`n", totalComments)

        return stats
    }
}

; Usage - complete blog system
blog := Blog("Tech Insights", "A blog about technology and programming")

; Register authors
alice := blog.RegisterAuthor(Author("alice_codes", "alice@blog.com", "Alice Johnson"))
    .SetBio("Full-stack developer passionate about web technologies")

bob := blog.RegisterAuthor(Author("bob_dev", "bob@blog.com", "Bob Smith"))
    .SetBio("DevOps engineer and cloud enthusiast")

; Create posts
post1 := blog.CreatePost(alice, "Getting Started with AutoHotkey v2",
    "AutoHotkey v2 brings many exciting new features to the scripting language. " .
    "In this post, we'll explore the key changes and how to migrate from v1. " .
    "The new syntax is more consistent and modern, making it easier to write clean code.")

post1.AddCategory("Programming").AddCategory("AutoHotkey")
    .AddTag("tutorial").AddTag("beginner").AddTag("ahk-v2")
    .Publish()

post2 := blog.CreatePost(bob, "Docker Best Practices for 2024",
    "Docker has become an essential tool for modern development. " .
    "Here are the top 10 best practices every developer should follow " .
    "to create efficient and secure containerized applications.")

post2.AddCategory("DevOps").AddCategory("Containers")
    .AddTag("docker").AddTag("best-practices").AddTag("security")
    .Publish()

post3 := blog.CreatePost(alice, "Building RESTful APIs with Node.js",
    "Learn how to build scalable RESTful APIs using Node.js and Express. " .
    "We'll cover routing, middleware, error handling, and authentication.")

post3.AddCategory("Programming").AddCategory("Backend")
    .AddTag("nodejs").AddTag("api").AddTag("javascript")
    .Publish()

; Add comments
comment1 := post1.AddComment(bob, "Great tutorial! Very helpful for beginners.")
post1.AddComment(alice, "Thanks Bob! I'm planning a follow-up post on advanced topics.")

comment1.AddReply(Comment(alice, "Part 2 coming next week!"))

post2.AddComment(alice, "Excellent tips on container security!")

; Simulate views
post1.IncrementViews().IncrementViews().IncrementViews()
    .IncrementViews().IncrementViews().IncrementViews()
    .IncrementViews().IncrementViews().IncrementViews()
    .IncrementViews()  ; 10 views

post2.IncrementViews().IncrementViews().IncrementViews()
    .IncrementViews().IncrementViews()  ; 5 views

post3.IncrementViews().IncrementViews().IncrementViews()
    .IncrementViews().IncrementViews().IncrementViews()
    .IncrementViews()  ; 7 views

; Display post
MsgBox(post1.ToString())

; Show comments
MsgBox("Comments on '" . post1.title . "':`n`n" . post1.comments.Map((c) => c.ToString()).Join("`n"))

; Filter posts
MsgBox("Programming posts:`n`n" . blog.GetPostsByCategory("Programming").Map((p) => p.title).Join("`n"))

MsgBox("Posts by Alice:`n`n" . blog.GetPostsByAuthor(alice.authorId).Map((p) => p.title).Join("`n"))

MsgBox("Posts tagged 'tutorial':`n`n" . blog.GetPostsByTag("tutorial").Map((p) => p.title).Join("`n"))

; Search
MsgBox("Search results for 'API':`n`n" . blog.SearchPosts("API").Map((p) => p.title).Join("`n"))

; Popular posts
MsgBox("Popular posts:`n`n" . blog.GetPopularPosts(3).Map((p) => Format("{1} ({2} views)", p.title, p.views)).Join("`n"))

; Blog stats
MsgBox(blog.GetBlogStats())

; Author info
MsgBox(alice.ToString() . "`n`n" . alice.bio)
