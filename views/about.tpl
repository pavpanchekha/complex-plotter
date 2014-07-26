%rebase master title="About"
<img src="/api?f=exp%28-pi%20*%20sec%28pi%20*%20z/2%29%29" class="float" />
<p>
  This website plots complex functions.
  Each point in the image has a color
  based on the value of a complex function at that point on the plane:
  the brighness of the point represents the absolute value,
  and the hue represents its argument.
  If you plot <code>1/z</code>,
  you will see a very sharp bright point in the middle. That's the pole.
  You'll also see the colors cycle in the opposite order
  of the graph of <code>z</code>,
  because <code>1/z</code> negates the argument of its input.
</p>
<p>
  Sam Fingeret created the original complex plotter,
  and <a href="https://pavpanchekha.com">Pavel Panchekha</a>
  built the website. Enjoy!
</p>
<h2>List of Functions</h2>
<ul>
  <li><code>abs</code>, <code>arg</code>, <code>conj</code>, <code>imag</code>, <code>real</code></li>
  <li><code>exp</code>, <code>log</code>, <code>pow</code>, <code>sqrt</code></li>
  <li><code>sin</code>, <code>cos</code>, <code>tan</code>, <code>cot</code>, <code>sec</code>, <code>csc</code></li>
  <li><code>sinh</code>, <code>cosh</code>, <code>tanh</code>, <code>coth</code>, <code>sech</code>, <code>csch</code></li>
  <li><code>asin</code>, <code>acos</code>, <code>atan</code>, <code>asec</code>, <code>acsc</code>, <code>acot</code></li>
  <li><code>asinh</code>, <code>acosh</code>, <code>atanh</code>, <code>asech</code>, <code>acsch</code>, <code>acoth</code></li>
  <li><code>gamma</code></li>
  <li><code>eta</code>, <code>zeta</code>*, <code>xi</code>*&dagger;</li>
  <li><code>ccrand</code> (<i> 0 &le; a, b &le; 1</i>)</li>
  <li><code>cc</code></li>
</ul>

<p>
  Functions marked with a <strong>*</strong> have minor errors introduced by
  the approximations that make calculation possible, and these minor
  errors may manifest themselves as phantom poles or zeros. For example,
  the implementation of the zeta function
  has poles that are extremely close to zeros that are
  supposed to cancel them.
  Functions marked with a <strong>&dagger;</strong> are implemented but are
  extremely slow
  If you have better ways of calculating
  these functions, write!
</p>

<h2>List of Constants</h2>
<ul>
  <li><code>pi</code>, <code>e</code>, <code>masc</code> (Euler-Mascheroni)</li>
</ul>

<h2>Feedback and Bugs</h2>

<p>
  Have comments, suggestions, or bug reports?
  Report them on
  <a href="https://github.com/pavpanchekha/complex-plotter/issues">GitHub</a>.
</p>

<h2>Programmer's API</h2>
<p>
  The site offers an API for programmers.
  The goal is to allow smartphones to plot complex functions.
  If you want to plot these functions on a full desktop computer,
  just <a href="https://github.com/pavpanchekha/complex-plotter">download the source code</a>.
</p>

<p>The API consists of a single endpoint:
  send a <code>GET</code> request to <code>http://complex.pavpanchekha.com/api</code>,
  with any of the following parameters:</p>

<table>
  <thead>
    <th scope="col">Parameter</th>
    <th scope="col">Description</th>
  </thead>
  <tbody>
    <tr><td><code>f</code></td><td>The function to plot. If
        not specified, an error occurs. In general, I'd really
        like it if you kept the default image, if your application uses
        one, bundled somewhere within your application. Don't hit the
        server on startup.</td></tr>
    <tr><td><code>w</code> and <code>h</code></td><td>Width and height.
        The default is 300 by 300 (just right for the iPhone screen).</td></tr>
    <tr><td><code>l</code>, <code>b</code>, <code>t</code>, <code>r</code>
        </td><td>The real coordinate of the left, bottom, top, and right
        of the viewing window. The default is 2 and -2 as makes sense.</td></tr>
  </tbody>
</table>

<p>The actual parsing and generation of the image all happen server-side,
so functions can be passed exactly as they normally would. If everything
goes well, the status code should be <code>200</code> and the response
content should be a <abbr title="Portable Network Graphics">PNG</abbr>
image. If something bad happens, the response code is
<code>400</code> and the response body is empty. It's up to you to figure
out what went wrong in that case.</p>
