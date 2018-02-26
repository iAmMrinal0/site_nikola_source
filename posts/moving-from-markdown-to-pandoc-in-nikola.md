<!--
.. title: Moving from Markdown to Pandoc in Nikola
.. slug: moving-from-markdown-to-pandoc-in-nikola
.. date: 2018-01-27 18:49:53 UTC+05:30
.. tags: markdown, pandoc, hacks, tutorial, nikola, haskell, python, kate, pygments
.. category: technical
.. link:
.. description: Steps to move from Markdown to Pandoc in Nikola
.. type: text
-->

So, the other day there was a hackathon at Geekskool and all the students were building something from the range of UNO bot, jump forms(feedback forms but better), and an app which detects code from an image and analyses/executes the same and there I was, wondering how to properly format nested lists in Markdown for one of my [posts.](../../blog/the-curious-case-of-matching-memory-locations-in-python/) <!-- TEASER_END -->

And thus started a long search of how to solve the issue of getting nested unordered lists in Nikola(which is a static site generator I use for this site.) So first things first, what does Nikola use to parse Markdown to HTML? Nikola docs say that it uses `markdown` by `Python-Markdown` found on [GitHub](https://github.com/Python-Markdown/markdown) and I started checking for open issues, if any, about nested lists and I found [one](https://github.com/Python-Markdown/markdown/issues/3) where the maintainer suggests to use 4 spaces for nested lists to work. And when I tried it, it looked bad with too much of space and hence I searched for alternative tools which supported GitHub-Flavored Markdown with the condition that I shouldn't have to make major changes to my existing setup.

That's when I came across Pandoc(though I had heard about it), I finally found a proper use case. Let's get started and solve the nested lists problem and whatever else that may come our way.

Install pandoc based on instructions from the [official site.](https://pandoc.org/installing.html)

Following are the modifications to be made to the `conf.py` file of your Nikola site:

* Comment the `markdown` compiler and uncomment the `pandoc` compiler in the `COMPILERS` variable.
* Uncomment `PANDOC_OPTIONS` variable and add `-f, gfm` to the array; `-f/--from` means the input format flag which is GitHub-Flavored Markdown hence the `gfm`.

And that's it, now when you build your site, Nikola will use pandoc and generate the site for you. However, there's a caveat. If you have any code blocks, the code highlighting theme doesn't seem to work now because the way pandoc generates is different than how Nikola expects it. A bit of info:

* Markdown file runs through the `markdown` compiler which gives `body` part of the HTML and then Nikola inserts the rest of the `head` and templated content and applies the style using [Pygments.](http://pygments.org/)
* Whereas, Pandoc generates a complete HTML file with `head` and `style` information which Nikola unfortunately ignores and takes only whatever is inside the `body` tag and generates the final HTML with the templated content.

What we want is to preserve the style information so that code highlighting remains as how we want it. And so, started perusing the pandoc docs to be kind of disappointed that style information could not be generated as a standalone file as an input to Nikola. So, what I ended up doing is generate a dummy output file with some code as input to pandoc. Copy the following code snippet(or write some code of your choice) and paste it in a new file as `input.md`:

``` python
def func():
    a = 100
    b = "hello".split()
    c = [1,2,3,4].join('')
```
And run the following command:

`$ pandoc -f gfm -o output.html input.md --highlight-style=kate -s`

I personally like the `kate` theme and for a list of supported themes check out the `--highlight-style` flag in the [Pandoc docs.](https://pandoc.org/MANUAL.html#general-writer-options)

Now that you have a generated `output.html`, open it and copy the generated `style` information i.e. content inside the `<style>` tags and paste them in the end at `assets/css/custom.css`

After building your site, you should now see the syntax highlighted in the color theme that you selected while using pandoc. Currently, a minor hurdle is that whenever you want to change to a different theme, you should generate the style information and copy paste the CSS from the output HTML file.

So we have moved our Nikola site from `markdown` to `pandoc` compiler with proper syntax highlighting.

References:
* CSS for Kate theme used in this site: [link](https://github.com/iAmMrinal0/iammrinal0.github.io/commit/20445519e447d4c0a04a5efc086fe1e6a9082a7f#diff-311a161192e4ffa168423a7a9943b548)
