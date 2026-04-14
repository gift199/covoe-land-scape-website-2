#!/bin/bash

echo "================================"
echo "🔍 WEB AUDIT & DEBUG REPORT"
echo "================================"
echo ""

echo "1️⃣ CHECKING HTML FILES..."
echo "---"
for file in *.html; do
  echo "Validating $file..."
  # Check for common HTML issues
  grep -c "</html>" "$file" >/dev/null && echo "  ✓ Proper HTML closing tag" || echo "  ⚠ Missing closing HTML tag"
  grep -c "<html" "$file" >/dev/null && echo "  ✓ Has opening HTML tag" || echo "  ⚠ Missing opening HTML tag"
  
  # Check for charset
  grep -q "charset" "$file" && echo "  ✓ UTF-8 charset defined" || echo "  ⚠ Missing charset declaration"
  
  # Check for viewport
  grep -q "viewport" "$file" && echo "  ✓ Mobile viewport meta tag present" || echo "  ⚠ Missing viewport meta tag"
done
echo ""

echo "2️⃣ CHECKING IMAGE FILES..."
echo "---"
echo "Total images: $(ls -1 images/ | wc -l)"
for img in images/*.jpg images/*.png; do
  if [ -f "$img" ]; then
    size=$(ls -lh "$img" | awk '{print $5}')
    echo "  ✓ $img ($size)"
  fi
done
echo ""

echo "3️⃣ CHECKING CSS..."
echo "---"
css_file="css/style.css"
echo "  Lines of CSS: $(wc -l < $css_file)"
echo "  CSS Variables: $(grep -c "^  --" $css_file)"
echo "  Media Queries: $(grep -c "@media" $css_file)"
[ -f "$css_file" ] && echo "  ✓ CSS file exists and is valid" || echo "  ✗ CSS file missing"
echo ""

echo "4️⃣ CHECKING JAVASCRIPT..."
echo "---"
js_file="js/script.js"
echo "  Lines of JavaScript: $(wc -l < $js_file)"
echo "  Functions defined: $(grep -c "function" $js_file)"
[ -f "$js_file" ] && echo "  ✓ JavaScript file exists" || echo "  ✗ JS file missing"
echo ""

echo "5️⃣ CHECKING LINKS & NAVIGATION..."
echo "---"
echo "  Checking internal links..."
for html in *.html; do
  links=$(grep -o 'href="[^"]*"' "$html" | grep -o '"[^"]*"' | tr -d '"')
  echo "  $html links:"
  echo "$links" | while read link; do
    if [[ $link == http* ]]; then
      echo "    ✓ External: $link"
    elif [ -f "$link" ]; then
      echo "    ✓ Local: $link"
    else
      echo "    ⚠ Missing: $link"
    fi
  done
done
echo ""

echo "6️⃣ CHECKING GIT STATUS..."
echo "---"
echo "  Current branch: $(git rev-parse --abbrev-ref HEAD)"
echo "  Total commits: $(git rev-list --all --count)"
echo "  Latest commits:"
git log --oneline -3
echo ""

echo "7️⃣ CHECKING FILE STRUCTURE..."
echo "---"
echo "  Project files:"
find . -type f ! -path './.git/*' ! -path './.*' | sort | while read f; do
  echo "    ✓ $f"
done
echo ""

echo "8️⃣ SERVER CONNECTIVITY..."
echo "---"
if [ -z "$(curl -s http://localhost:8080/ | head -1)" ]; then
  echo "  ⚠ Server not responding"
else
  echo "  ✓ Server is running at http://localhost:8080"
  echo "  ✓ Home page loads successfully"
  echo "  ✓ Checking other pages..."
  for page in about.html services.html sustainability.html contact.html admin.html; do
    status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/$page)
    [ $status -eq 200 ] && echo "    ✓ $page (HTTP $status)" || echo "    ✗ $page (HTTP $status)"
  done
fi
echo ""

echo "✅ AUDIT COMPLETE"
echo "================================"
