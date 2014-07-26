%rebase master title="Plotter"
<form method="get" action=".">
  <input name="f" id="f" value="{{func}}"/>
  <a href="#" id="viewwind"><img src="resources/images/resize.png" /></a>
  <a href="#" id="helpbut"><img src="resources/images/help.png" /></a>
  <div id="help" class="note">
    <a href="#" id="helpclose"><img src="resources/images/cross.png"/></a>
    <p>
      Enter a function of <code>z</code>,
      in standard mathematical notation.
      You're allowed the basic operations:
      addition, subtraction, division, multiplication,
      and exponentiation (with <code>^</code>).
      For conjugation write <code>~z</code>,
      and for absolute value write <code>|z|</code>.
      The functions <code>conj(z)</code>, <code>abs(z)</code>,
      and <code>pow(z, w)</code> do what you'd expect.
      Comparison operators use an absolute values when passed complex arguments.
      For example, <code>(imag(z) &lt; 0) * 2 + (imag(z) &gt; 0) * i</code>
      is a piecewise complex function.
    </p>
    <p>
      Some standard functions are provided,
      and also some not-so-standard functions like
      <code>gamma</code>, <code>eta</code>, and <code>zeta</code>.
      You can see a full list on the <a href="about">about</a> page.
      All functions <em>will</em> take principal branches,
      so you will see sharp discontinuities in, for example,
      <code>sqrt(z)</code>.
    </p>
    <p>
      Some constants are also built in:
      <code>pi</code>, <code>i</code>, and <code>e</code>,
      along with the Euler-Mascheroni constant <code>masc</code>.
      A full list is again on the <a href="about">about</a> page.
    </p>
  </div>
  <button id="submit" type="submit">Plot!</button>
  <div id="img">
    <img src='/{{img}}' width="750px" height="750px" alt="{{func}}"/>
    <div id="cont">
      <div id="ll" class="note">
        <i><input name="l" id="l" value="{{l}}" /> + <input name="b" id="b" value="{{b}}"/>i</i>
      </div>
      <div id="tr" class="note">
        <i><input name="r" id="r" value="{{r}}" /> + <input name="t" id="t" value="{{t}}"/>i</i>
      </div>
      <div id="size" class="note">
        <input name="w" id="w" value="{{w}}" /> &times; <input name="h" id="h" value="{{h}}" />
      </div>
      <div id="resetbut" class="note">
        <a href="#" id="zoom">Zoom out 2×</a> |
        <a href="#" id="reset">Reset Window</a> |
        <a href="#" id="clear">Clear Selection</a>
      </div>
    </div>
  </div>
</form>


<script type="text/javascript" src="/resources/scripts/plotter.js"></script>
