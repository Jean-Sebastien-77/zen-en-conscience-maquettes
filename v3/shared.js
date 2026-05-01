// Inclusions de partials (nav + footer)
async function include(id, url){
  const mount = document.getElementById(id);
  if(!mount) return;
  try{
    const res = await fetch(url);
    mount.outerHTML = await res.text();
  }catch(e){console.error('include failed',url,e);}
}

async function bootstrap(){
  await Promise.all([
    include('nav-mount','partials/_nav.html'),
    include('footer-mount','partials/_footer.html'),
  ]);
  // Active link
  const page = document.body.dataset.page;
  if(page){document.querySelectorAll(`.nav-links a[data-page="${page}"]`).forEach(a=>a.classList.add('active'));}
  // Mobile menu
  const burger=document.querySelector('.nav-burger');
  const menu=document.querySelector('.mobile-menu');
  if(burger && menu){
    burger.addEventListener('click',()=>{
      menu.classList.toggle('open');
      document.body.style.overflow=menu.classList.contains('open')?'hidden':'';
    });
    menu.querySelectorAll('a').forEach(a=>a.addEventListener('click',()=>{
      menu.classList.remove('open');document.body.style.overflow='';
    }));
  }
  // Reveal au scroll
  const io=new IntersectionObserver((entries)=>{
    entries.forEach(e=>{if(e.isIntersecting){e.target.classList.add('in');io.unobserve(e.target);}});
  },{rootMargin:'0px 0px -10% 0px',threshold:0.05});
  document.querySelectorAll('.reveal').forEach(el=>io.observe(el));
  // Parallax léger sur les éléments [data-parallax]
  const parallaxEls=document.querySelectorAll('[data-parallax]');
  if(parallaxEls.length && !window.matchMedia('(prefers-reduced-motion: reduce)').matches){
    let ticking=false;
    const updateParallax=()=>{
      const vh=window.innerHeight;
      parallaxEls.forEach(el=>{
        const rect=el.getBoundingClientRect();
        if(rect.bottom<0||rect.top>vh) return;
        const progress=(rect.top+rect.height/2-vh/2)/vh;
        const speed=parseFloat(el.dataset.parallax)||0.3;
        const shift=`${-progress*speed*100}px`;
        if(el.classList.contains('leaf')){
          el.style.setProperty('--shift',shift);
        }else{
          el.style.transform=`translateY(${shift})`;
        }
      });
      ticking=false;
    };
    window.addEventListener('scroll',()=>{if(!ticking){requestAnimationFrame(updateParallax);ticking=true;}},{passive:true});
    updateParallax();
  }
  // FAQ
  document.querySelectorAll('.faq-q').forEach(btn=>{
    btn.addEventListener('click',()=>btn.parentElement.classList.toggle('open'));
  });
}
document.addEventListener('DOMContentLoaded',bootstrap);
