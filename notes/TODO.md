
<div align="center" style="display: flex; flex-direction: column;">
<img src=".github/images/main_gif.gif" width="200">
</div>

<h1 align="center">
  <div >
<span > Personal configuration files </span>
  </div>
  <br>
</h1>

P0
- I would like to type on laptop and also use its touchpad, but actually pass all these signals to my primary dekstop pc with no input lag, is it possible?

If you just want laptop as a dumb keyboard+touchpad (no KVM switching, always forwarding), use wl-kvm or simply SSH + evdev forwarding:

My recommendation for you: Input Leap — it's the most polished, has a GUI, handles touchpad gestures well, and your Tailscale setup (I see tailscale-auth-key in your secrets) means you can use it securely between machines without LAN proximit

input-leap
sudo firewall-cmd --add-port=24800/tcp --permanent
sudo firewall-cmd --reload

Enter your desktop's IP address (or Tailscale IP — e.g. 100.x.x.x)

tailscale ip -4  # run on desktop to get its IP
cp /usr/share/applications/input-leap.desktop ~/.config/autostart/


Best options for Fedora/Wayland
1. Sunshine + Moonlight ⭐ recommended
Game-streaming protocol — extremely low latency, hardware-accelerated encoding.

Desktop: runs Sunshine (captures screen, encodes GPU)
Laptop: runs Moonlight (decodes, displays)
Works over Tailscale too. Latency is typically 5–15ms on LAN, 20–40ms over Tailscale.

P1
- I would like to have containarized neovim setup
