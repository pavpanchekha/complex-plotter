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
        <a href="#" id="reset">Reset Window</a> |
        <a href="#" id="clear">Clear Selection</a>
      </div>
    </div>
  </div>
</form>


<script>
  data = {f: "{{func}}", w: {{w}}, h: {{h}}, t: {{t}}, b: {{b}}, r: {{r}}, l: {{l}}};

  $(function () {
    api = $.Jcrop("#img img");

    $("#helpbut").click(function () {
      $("#help").toggle();
      return false;
    });

    $("#helpclose").click(function () {
      $("#help").hide();
      return false;
    });

    $("#viewwind").click(function () {
      $("#cont").toggle();
      return false;
    });

    $("#reset").click(function () {
      $("#w").val(750);
      $("#h").val(750);
      $("#t").val(2);
      $("#b").val(-2);
      $("#l").val(-2);
      $("#r").val(2);
      api.release();
      return false;
    });

    $("#clear").click(function () {
      $("#w").val(data.w);
      $("#h").val(data.h);
      $("#t").val(data.t);
      $("#b").val(data.b);
      $("#l").val(data.l);
      $("#r").val(data.r);
      api.release();
      return false;
    });

    $("#submit").click(function () {
      api.destroy();
      $("#img img").attr("src", "/api?f=" + escape($("#f").attr("value")));
      api = $.Jcrop("#img img");
      api.setOptions({onChange: update_box, onSelect: update_box, aspectRatio: 1});
      return false;
    });

    function round(x, prec) {
      var len = String(Math.floor(x)).length;
      return String(x).substring(0, len + prec + 1);
    }

    function update_box(e) {
      var xmult  = (data.r - data.l) / 750;
      var xshift = (data.r + data.l) / 750;
      var ymult  = (data.t - data.b) / 750;
      var yshift = (data.t + data.b) / 750;

      $("#cont").show();
      $("#r").val(round(xmult * (e.x2 - 375) + xshift, 3));
      $("#t").val(round(ymult * (375 - e.y) + yshift, 3));
      $("#l").val(round(xmult * (e.x - 375) + xshift, 3));
      $("#b").val(round(ymult * (375 - e.y2) + yshift, 3));
    }

    api.setOptions({onChange: update_box, onSelect: update_box, aspectRatio: 1});

    if ($("#l").attr("value") != "-2" ||
        $("#r").attr("value") != "2" ||
        $("#b").attr("value") != "-2" ||
        $("#t").attr("value") != "2") {
      $("#cont").show();
    }
    
    $("#helpbut").after($("<a href='#' id='galleryadd'><img src='resources/images/add-gallery.png' /></a>"));
    function handle_bookmark() {
      var w = $("#w").val();
      var h = $("#h").val();
      var l = $("#l").val();
      var b = $("#b").val();
      var t = $("#t").val();
      var r = $("#r").val();
      var f = $("#f").val();

      var desc = prompt("Check to make sure that you actually want to save this. I mean, the gallery has some pretty nice shots... does yours belong there? If you really think so... well, write a short description here.");
      // TODO: This is ugly and stupid. Fix to make proper dialog box
      if (!desc) return false;

      $.post("gallery/add", {f: f, h: h, l: l, b: b, t: t, r: r, desc: desc}, function () {
        $("#galleryadd").fadeTo("slow", 1);
        $("#galleryadd").unbind("click", handle_bookmark);
      });
      return false;
    }

    $("#galleryadd").fadeTo("fast", .5).click(handle_bookmark);
  });
</script>
