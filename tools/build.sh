#!/bin/sh
# yoichi.html（ゲーム本体）から、GitHub Pages で公開する index.html を作る。
# ゲームを直したら yoichi.html を編集して、このスクリプトを実行する。
set -e
cd "$(dirname "$0")/.."

{
cat <<'EOF'
<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<title>BAR 夜市</title>
<meta name="description" content="お客さんの注文を覚えて出す、バーの記憶ゲーム。">
<meta name="theme-color" content="#130d10">
<link rel="manifest" href="manifest.webmanifest">
<link rel="icon" href="icons/icon-192.png">
<link rel="apple-touch-icon" href="icons/apple-touch-icon.png">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="apple-mobile-web-app-title" content="夜市">
<style>:root{box-sizing:border-box;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0;padding:0}img{max-width:100%}[hidden]:not([hidden=until-found i]){display:none!important}</style>
</head>
<body>
EOF
# 先頭の <title> と Claude 用の meta は head に移したので外す
sed -e '/^<title>/d' -e '/claude:viewport-fit-sides/d' yoichi.html
cat <<'EOF'
<style>
.dl{display:flex;align-items:center;justify-content:center;gap:8px;width:100%;box-sizing:border-box;padding:13px 10px;border:0;border-radius:8px;cursor:pointer;
  background:var(--neon);color:#fff;font-family:var(--body);font-weight:900;font-size:17px;line-height:1.3;box-shadow:0 0 14px rgba(255,92,147,.55)}
.dl svg{flex:none;width:22px;height:22px}
.dl span{display:flex;flex-direction:column;align-items:center;white-space:nowrap}
.dl small{font-size:13px;font-weight:700}
.dl:active{transform:scale(.98)}
.dl:focus-visible{outline:3px solid var(--amber);outline-offset:3px}
.steps{margin:0;padding-left:1.4em;text-align:left;font-size:15px;line-height:1.7;color:var(--fg)}
.steps b{color:var(--amber)}
.pointer{position:absolute;left:50%;bottom:6px;transform:translateX(-50%);color:var(--amber);font-size:28px;line-height:1;animation:bob 1s ease-in-out infinite}
@keyframes bob{50%{transform:translate(-50%,6px)}}
@media (prefers-reduced-motion:reduce){.pointer{animation:none}}
</style>
<script>
// 「アプリをダウンロードして遊ぶ」ボタン。ホーム画面から開いているときは出さない
(() => {
  const standalone = matchMedia('(display-mode: standalone)').matches || navigator.standalone;
  const ua = navigator.userAgent;
  const ios = /iPhone|iPad|iPod/.test(ua) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
  const android = /Android/.test(ua);
  let promptEvt = null;
  addEventListener('beforeinstallprompt', e => { e.preventDefault(); promptEvt = e; });

  if (!standalone) {
    document.getElementById('open').insertAdjacentHTML('afterend',
      `<button class="dl" id="dlBtn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 3v12M7 10l5 5 5-5M5 20h14"/></svg><span>アプリをダウンロードして遊ぶ<small>（無料）</small></span></button>`);
    document.getElementById('app').insertAdjacentHTML('beforeend', `
      <div class="ov" id="dlOv" hidden style="z-index:12" role="dialog" aria-modal="true" aria-labelledby="dlTitle">
        <div class="card"><h2 id="dlTitle"></h2><ol class="steps" id="dlSteps"></ol><button class="btn" id="dlOk">OK</button></div>
        <div class="pointer" id="dlPointer" hidden aria-hidden="true">↓</div>
      </div>`);
    const ov = document.getElementById('dlOv');
    const show = (title, steps, pointDown) => {
      document.getElementById('dlTitle').textContent = title;
      document.getElementById('dlSteps').innerHTML = steps.map(s => `<li>${s}</li>`).join('');
      document.getElementById('dlPointer').hidden = !pointDown;
      ov.hidden = false; document.getElementById('dlOk').focus();
    };
    const close = () => { ov.hidden = true; document.getElementById('dlBtn').focus(); };
    document.getElementById('dlOk').addEventListener('click', close);
    ov.addEventListener('click', e => { if (e.target === ov) close(); });
    document.addEventListener('keydown', e => { if (e.key === 'Escape' && !ov.hidden) close(); });

    document.getElementById('dlBtn').addEventListener('click', async () => {
      if (promptEvt) {
        promptEvt.prompt();
        await promptEvt.userChoice.catch(() => {});
        promptEvt = null;
      } else if (ios) {
        show('iPhoneに追加する方法', ['画面下の <b>共有ボタン</b>（四角から矢印が上に出ているマーク）を押す', '<b>「ホーム画面に追加」</b>を押す', '右上の <b>「追加」</b>を押す'], true);
      } else if (android) {
        show('Androidに追加する方法', ['右上の <b>︙</b>（縦に点3つ）を押す', '<b>「アプリをインストール」</b>か<b>「ホーム画面に追加」</b>を押す', '<b>「インストール」</b>を押す'], false);
      } else {
        location.href = 'install.html';
      }
    });
    addEventListener('appinstalled', () => { const b = document.getElementById('dlBtn'); if (b) b.hidden = true; });
  }
  if ('serviceWorker' in navigator) addEventListener('load', () => navigator.serviceWorker.register('sw.js').catch(() => {}));
})();
</script>
</body>
</html>
EOF
} > index.html

# 公開のたびにキャッシュ名を変えて、古い版が残らないようにする
sed -i "s/^const CACHE = .*/const CACHE = 'yoichi-$(date +%Y%m%d%H%M%S)';/" sw.js
echo "index.html を作りました"
