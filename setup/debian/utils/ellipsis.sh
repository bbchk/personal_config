# ellipsis.sh

# Function to show animated ellipsis during package installation
animate_ellipsis() {
  local pid=$1
  local p_name=$2
  local i=0

  while kill -0 "$pid" 2>/dev/null; do
    dots=$(printf "%*s" $(( (i % 4) + 1 )) '.')
    printf "\rInstalling package: $p_name %-4s" "$dots"
    sleep 0.5
    ((i++))
  done
}
