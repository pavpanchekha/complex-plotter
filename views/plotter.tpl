%rebase master title="Plotter"
<form method="get" action=".">
  <input name="f" id="f" value="{{func}}"/>
  <a href="#" id="viewwind"><img src="resources/images/resize.png" /></a>
  <a href="#" id="helpbut"><img src="resources/images/help.png" /></a>
  <div id="help" class="note">
    <a href="#" id="helpclose"><img src="resources/images/cross.png"/></a>
    <p>
    The format for functions: enter a function of <code>z</code>.
    Basically you're allowed the basic operations: addition,
    subtraction, division, multiplication, and exponentiation. Conjugation
    can be done with <code>~z</code>, and absolute value with <code>|z|</code>.
    You can call <code>conj(z)</code>, <code>abs(z)</code>, and <code>pow(z,
      w)</code> as well.
    Comparison operators work, though they take absolute values of their 
    parameters. So, for example, <code>(imag(z) &lt; 0) * 2 + (imag(z) &gt; 0) * i</code>
    will give you a piecewise complex function.
    Then there's the issue of doing complex numbers. To get <i>a + bi</i>, type in
    <code>cc(a, b)</code>. But, if you're willing to use all of my
    CPU time and reduce me to alcoholism, you can instead do
    <code>a + b*i</code>. Just, you know, be aware of your actions.
    With great power comes great responsibility.
    </p>
    <p>
    Then there's the question of what functions are allowed. The answer
    is that anything that comes standard with the <code>complex</code>
    library for <code>C++</code> should work, which doesn't give you
    that much: <code>arg</code>, <code>sin</code>, <code>exp</code>,
    <code>pow</code>. A few other functions are also included:
    <code>gamma</code>, <code>eta</code>, and <code>zeta</code>.
    You can see a full list on the <a href="about">about</a>
    page. All functions <em>will</em> take principal branches,
    so you will see sharp discontinuities in, for example,
    <code>pow(z, .5)</code>.
    </p>
    <p>
    On a good note, <code>pi</code> is a builtin constant.
    As is <code>e</code>. For the novelty-seekers, there's even the
    Euler-Mascheroni constant, as <code>masc</code> (<code>gamma</code> was taken).
    A full list can be found on the <a href="about">about</a>
    page.
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
