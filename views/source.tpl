%rebase master title="Source Code", extrahead='<script src="/resources/libraries/highlight.js"></script><link rel="stylesheet" href="/resources/libraries/highlight.css" />'
<script> hljs.initHighlightingOnLoad(); </script>

The source code for this site is maintained in <a href="http://git-scm.com">
git</a>, and can be found on
<a href="https://github.com/pavpanchekha/complex-plotter">GitHub</a>.
Feel free to view the full code, including the website core, there.

<h2>Complex Plotter</h2>
<p>
This file implements the core of the plotter core. You'll note that
the parser we use just inserts the parsed input straight into
<code>C++</code> code. Yes, that's massively insecure. We know.  Your
input is passed through a parser that pretties it up and also tries
its best to generate safe code; see below for the parser.
</p>
<pre><code
class="language-cpp">{{complex}}</code></pre>

<h2>Complex Function Library</h2>
<p>
While the core of the complex functionality in the plotter is provided by
the <code>C++</code> <abbr title="Standard Template Library">STL</abbr>,
this library does not provide many functions mathematicians are
accustomed to, either because these functions are simply shortcuts
(<code>tanh</code>, for example), or because they are so rarely useful
to programmers (e.g. <code>zeta</code>). Thus, these functions are
implemented in a seperate library.
</p>
<pre><code class="language-cpp">{{ccfunc}}</code></pre>

<h2><code>mathparse.parser</code></h2>
<p>
Your input on the web is not spliced directly into <code>C++</code>;
instead, it is first passed through a parser that expands calls like
<code>z^5</code>, and also works to ensure that only safe code is
inserted into the image generator.
</p>
<pre><code class="language-python">{{mathparse}}</code></pre>

<h2>Licensing</h2>
<p>All code on this page, and all other code in this web site not
entered by users or with its own license header, is licensed under
the terms of the <abbr title="GNU Public License">GPL</abbr>, <a
  href="http://www.gnu.org/licenses/gpl-3.0-standalone.html">version
  3</a> or higher. If you are
unsure of whether or not you may use this code in a project of your
own, feel free to contact the authors.</p>
<p>All code is &copy 2009 Pavel Panchekha and Sam
Fingeret</p>
