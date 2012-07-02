%rebase master title="About"
<img src="img/output.png" class="float" />
<p>
What is this? It's some random complex function. Each point in the
image has a color based on the value of a complex
function at that point on the plane. The brighness of the point
represents the absolute value. Thus, if you graph <code>1/z</code>,
you will see a very sharp bright point in the middle. That's the pole.
</p>
<p>
On the other hand, the hue of a point represents the argument of the
function's value. Plotting <code>z</code> should give you a good idea
of the spectrum.
</p>
<p>
A note about the magicians who brought you this: Sam Fingeret
created the complex plotter itself. I (Pavel Panchekha) made a
few modifications, made a command line tool out of it, and built
the website. Enjoy!
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
the zeta function has poles that are extremely close to zeros that are
supposed to cancel them. We are looking for better ways of evaluating
these functions &mdash; write! But for now, please ignore these artifacts.
</p>
<p>
Functions marked with a <strong>&dagger;</strong> are implemented but are
extremely slow. The website's maintainer kindly asks that you don't hammer
his computer with these functions. If you have better ways of calculating
these functions, write!
</p>

<h2>List of Constants</h2>
<ul>
  <li><code>pi</code>, <code>e</code>, <code>masc</code> (Euler-Mascheroni)</li>
</ul>

<h2>Feedback and Bugs</h2>

<p>Have comments, suggestions, hate mail?  Send them along to <a
href="mailto:bugs+complex@pavpanchekha.com">my email address</a>.
That way, it's easy for me to track and fix any problems you
notice.</p>

<h2>Programmer's API</h2>
<p>The site offers an API for programmers. The main goal here is to
allow devices such as the iPhone and Android phones to have convenient
interfaces for the plotter. If your program runs on full desktop computers,
perhaps you shouldn't hammer my server and just download the source code
that we so nicely provide. That's right, just hit that link up on top.</p>

<p>Now then, the actual <abbr title="Application Programming
  Interface">API</abbr> &mdash; it's simple, really. All you have to do
is send a <code>GET</code> request to
<code>http://panchekha.no-ip.com:8082/complex/api</code>, with paremeters
specifying what sort of image you want. The table below represents the
paremeters:</p>

<table>
  <thead>
    <th scope="col">Parameter</th>
    <th scope="col">Description</th>
  </thead>
  <tbody>
    <tr><td><code>f</code></td><td>The actual function, urlencoded. If
        not specified, an error occurs. In general, I'd really
        like it if you kept the default image, if your application uses
        one, bundled somewhere within your application. Don't hit the
        server on startup.</td></tr>
    <tr><td><code>w</code> and <code>h</code></td><td>Width and height.
        The default is 300 by 300 (just right for the iPhone screen) except
        for the default image.</td></tr>
    <tr><td><code>l</code>, <code>b</code>, <code>t</code>, <code>r</code>
        </td><td>The real coordinate of the left, bottom, top, and right
        of the viewing window. The default is 2 or -2, depending on which
        makes sense.</td></tr>
  </tbody>
</table>

<p>The actual parsing and generation of the image all happen server-side,
so functions can be passed exactly as they normally would. If everything
goes well, the status code should be <code>200</code> and the response
content should be the <abbr title="Portable Network Graphics">PNG</abbr>
image itself. If something bad happens, the response code is
<code>400</code> and the response body is empty. It's up to you to figure
out what went wrong in that case.</p>
