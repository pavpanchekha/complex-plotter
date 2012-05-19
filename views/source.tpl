
<h2>Complex Plotter</h2>
<p>
This file implements the core of the plotter core. You'll note that the
parser we use just inserts the parsed input straight into <code>C++</code>
code. Yes, that's massively insecure. We know.
</p>
%(complex)s

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
%(ccfunc)s

<h2>Website Core</h2>
<p>
The web site is built on <code>mod_python</code>, and the code below
implements the core of the web site. It should give some idea of how
the <code>C++</code> files are constructed, compiled, and run. Please
don't write to say how hackish this all is.
</p>
%(index)s

<h2><code>mathparse.parser</code></h2>
%(mathparse)s

<h2>Licensing</h2>
<p>All code on this page, and all other code in this web site not
entered by users or with its own license header, is licensed under
the terms of the <abbr title="GNU Public License">GPL</abbr>, <a
  href="http://www.gnu.org/licenses/gpl-3.0-standalone.html">version
  3</a> or higher. The text of this license is available below. If you are
unsure of whether or not you may use this code in a project of your
own, feel free to contact the authors.</p>
<p>All code is copyrighted, &copy; year 2009, by Pavel Panchekha and Sam
Fingeret</p>