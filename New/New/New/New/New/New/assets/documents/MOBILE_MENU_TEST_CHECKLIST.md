# Mobile Menu Testing Checklist

## Quick Test Instructions

### Desktop Testing
1. Open any page in desktop view (width > 768px)
2. Resize browser to mobile view (width < 768px)
3. Click the hamburger menu (three lines)
4. Verify menu opens with visible text
5. Click a menu item - should navigate correctly
6. Click hamburger again - menu should close

### Mobile Device Testing

#### iOS Testing (iPhone/iPad)
- [ ] Safari - Tap hamburger menu
- [ ] Safari - Menu opens with dark text
- [ ] Safari - Menu items are clickable
- [ ] Safari - Dropdowns work (Tours & Safaris, Other Services, About Jetwide)
- [ ] Safari - Menu closes when tapping outside
- [ ] Safari - Hover effects show orange (#FE9900)
- [ ] Chrome iOS - Repeat above tests

#### Android Testing
- [ ] Chrome - Tap hamburger menu
- [ ] Chrome - Menu opens with dark text
- [ ] Chrome - Menu items are clickable
- [ ] Chrome - Dropdowns work
- [ ] Chrome - Menu closes when tapping outside
- [ ] Samsung Internet - Repeat above tests
- [ ] Firefox - Repeat above tests

### Pages to Test

#### Critical Pages (Test First)
1. [ ] index.html (Homepage)
2. [ ] pages/about-us.html
3. [ ] pages/visa-services.html
4. [ ] pages/kenyan-safaris.html
5. [ ] pages/contact.html

#### Package Pages (Sample Test)
1. [ ] pages/packages/dubai-honeymoon.html
2. [ ] pages/packages/maasai-mara-school-trip.html
3. [ ] pages/packages/maldives-resort-experience.html

### What to Look For

#### ✅ Expected Behavior
- Menu button appears on mobile (three horizontal lines)
- Button is easily tappable (good touch target size)
- Menu opens smoothly when tapped
- Menu items have dark text (#14132A) on white background
- Menu items turn orange (#FE9900) when tapped/hovered
- Dropdowns expand inline (not as overlays)
- Dropdown items are indented and visible
- Menu closes when tapping outside or tapping button again
- Page navigation works correctly

#### ❌ Issues to Report
- Menu doesn't open when tapped
- Text is invisible or too light to read
- Menu items overlap or are misaligned
- Dropdown arrows don't respond
- Menu doesn't close
- Touch events don't work
- Console errors in browser DevTools

### Browser DevTools Testing
1. Open Chrome DevTools (F12)
2. Switch to device toolbar (Ctrl+Shift+M)
3. Select "iPhone 12 Pro" or "Pixel 5"
4. Navigate to any page
5. Open Console tab
6. Tap hamburger menu
7. Check for errors in console
8. Verify no JavaScript errors

### Performance Check
- [ ] Menu opens within 100ms of tap
- [ ] No lag or delay
- [ ] Smooth animation
- [ ] No screen flicker
- [ ] No layout shift

### Accessibility Check
- [ ] Button has aria-label="Toggle mobile menu"
- [ ] Menu items are keyboard accessible
- [ ] Screen reader can announce menu state
- [ ] Focus indicators visible

### Cross-Browser Compatibility
- [ ] Chrome Mobile (Android/iOS)
- [ ] Safari (iOS)
- [ ] Samsung Internet (Android)
- [ ] Firefox Mobile (Android/iOS)
- [ ] Edge Mobile (Android/iOS)

## How to Report Issues

If you find any problems:

1. **Document the issue:**
   - Which page?
   - Which device/browser?
   - What happened vs what should happen?
   - Screenshot if possible

2. **Check browser console:**
   - Are there any errors?
   - What do the errors say?

3. **Test on another device:**
   - Does the same issue occur?

4. **Create a report:**
   ```
   Page: [URL or filename]
   Device: [iPhone 12, Samsung S21, etc.]
   Browser: [Safari, Chrome, etc.]
   Issue: [Description]
   Steps to Reproduce:
   1. 
   2. 
   3. 
   Expected: [What should happen]
   Actual: [What actually happened]
   ```

## Testing Priority

### Phase 1: Critical (Test Today)
- Homepage (index.html)
- About Us page
- Contact page
- One package page

### Phase 2: Important (Test This Week)
- All main navigation pages
- Sample of 5 package pages

### Phase 3: Complete (Test When Possible)
- All remaining package pages
- Edge cases and older devices

## Success Criteria
✅ All tested pages show working mobile menu
✅ No console errors
✅ Menu text is clearly visible
✅ Touch events respond immediately
✅ Navigation works correctly
✅ No layout issues or overlaps

---
*Created: November 3, 2025*
*Files Updated: 50 HTML files*
