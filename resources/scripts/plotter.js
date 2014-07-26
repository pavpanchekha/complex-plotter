// Included on plotter page; plots.

$(function () {
  data = {f: $("#f").prop("defaultValue"),
          w: +$("#w").prop("defaultValue"),
          h: +$("#h").prop("defaultValue"),
          t: +$("#t").prop("defaultValue"),
          b: +$("#b").prop("defaultValue"),
          l: +$("#l").prop("defaultValue"),
          r: +$("#r").prop("defaultValue")};

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

  $("#zoom").click(function() {
      $("#t").val(data.t * 2);
      $("#b").val(data.b * 2);
      $("#l").val(data.l * 2);
      $("#r").val(data.r * 2);
      api.release();
      $("#submit").click();
      return false;
  });

  $("#submit").click(function () {
    api.destroy();
    window.data = {f: $("#f").val(),
                   w: +$("#w").val(),
                   h: +$("#h").val(),
                   t: +$("#t").val(),
                   b: +$("#b").val(),
                   l: +$("#l").val(),
                   r: +$("#r").val()};
    $("#img img").attr("src",
                       "/api?f=" + escape(data.f) +
                       "&w=" + escape(data.w) +
                       "&h=" + escape(data.h) +
                       "&t=" + escape(data.t) +
                       "&b=" + escape(data.b) +
                       "&l=" + escape(data.l) +
                       "&r=" + escape(data.r));
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
    var xshift = (data.r + data.l) / 2;
    var ymult  = (data.t - data.b) / 750;
    var yshift = (data.t + data.b) / 2;

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
