%rebase master title="Gallery"
<ul id="gallery">
% for i, desc, f, w, h, l, b, r, t in gallery:
  <li>
    <a href="gallery/{{i}}">
      <img src="img/gallery-{{i}}.png" alt="{{f}}" />
      <code>{{f}}</code>
    </a>
  </li>
%end
</ul>
