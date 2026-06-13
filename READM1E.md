<div align="center">

<svg width="500" height="500" viewBox="0 0 500 500">

<style>
.x-arm{
  animation: assemble 2s ease-out forwards;
}

.ring{
  animation: spin 8s linear infinite;
  transform-origin:250px 250px;
}

.core{
  animation: pulse 1.8s infinite;
}

@keyframes assemble{
  from{
    opacity:0;
    transform:scale(0.7);
  }
  to{
    opacity:1;
    transform:scale(1);
  }
}

@keyframes spin{
  from{transform:rotate(0deg);}
  to{transform:rotate(360deg);}
}

@keyframes pulse{
  0%,100%{filter:brightness(1);}
  50%{filter:brightness(2);}
}
</style>

<!-- الحلقة -->

<g class="ring">
  <circle cx="250" cy="250" r="140"
          fill="none"
          stroke="#00ff55"
          stroke-width="12"
          stroke-dasharray="120 60"/>
</g>

<!-- X -->

<polygon class="x-arm"
points="60,60 180,110 250,200 220,230"
fill="#202020"
stroke="#00ff55"
stroke-width="2"/>

<polygon class="x-arm"
points="440,60 320,110 250,200 280,230"
fill="#202020"
stroke="#00ff55"
stroke-width="2"/>

<polygon class="x-arm"
points="60,440 180,390 250,300 220,270"
fill="#202020"
stroke="#00ff55"
stroke-width="2"/>

<polygon class="x-arm"
points="440,440 320,390 250,300 280,270"
fill="#202020"
stroke="#00ff55"
stroke-width="2"/>

<!-- القفل -->

<circle cx="250" cy="250"
        r="55"
        fill="#111"
        stroke="#c0c0c0"
        stroke-width="5"/>

<circle class="core"
        cx="250"
        cy="250"
        r="18"
        fill="#00ff55"/>

<path d="M250 225
         C235 225 230 240 230 250
         L270 250
         C270 240 265 225 250 225Z"
      fill="none"
      stroke="#00ff55"
      stroke-width="4"/>

</svg>

</div>
