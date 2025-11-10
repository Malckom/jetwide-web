/**
 * Jetwide WhatsApp Integration
 * Consistent WhatsApp CTA across all pages
 * Color: #25d366 (WhatsApp brand green)
 */

(function() {
  'use strict';

  const WHATSAPP_CONFIG = {
    phone: '254748538311',
    color: '#25d366',
    messages: {
      home: "Hello Jetwide, I'd like to book a safari package!",
      safari: "Hi Jetwide, I'm interested in booking this safari package: ",
      visa: "Hello Jetwide team, I'd like help with a visa application for [destination].",
      job: "Hi Jetwide, I am interested in overseas jobs in [sector/country].",
      airline: "Hi Jetwide, I want to book a flight from [city] to [destination] on [dates] for [number] passengers.",
      carhire: "Hi Jetwide, I'd like to hire a [vehicle type] from [start date] to [end date].",
      contact: "Hello Jetwide, I have a question about your services.",
      blog: "Hi Jetwide, I have a question about travel to Kenya.",
      general: "Hello Jetwide, I'd like to inquire about your services."
    }
  };

  /**
   * Create WhatsApp floating button
   */
  function createFloatingButton() {
    // Check if button already exists
    if (document.getElementById('jetwide-whatsapp-float')) {
      return;
    }

    const button = document.createElement('a');
    button.id = 'jetwide-whatsapp-float';
    button.href = getWhatsAppURL(WHATSAPP_CONFIG.messages.home);
    button.target = '_blank';
    button.rel = 'noopener noreferrer';
    button.setAttribute('aria-label', 'Chat with us on WhatsApp');
    button.className = 'jetwide-whatsapp-float';
    
    button.innerHTML = `
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M27.281 4.65C24.318 1.686 20.361 0.028 16.148 0C7.467 0 0.391 7.075 0.387 15.757C0.386 18.542 1.096 21.257 2.445 23.655L0.262 32L8.845 29.862C11.15 31.091 13.723 31.738 16.342 31.739H16.348C25.029 31.739 32.105 24.663 32.109 15.982C32.11 11.776 30.455 7.827 27.491 4.862L27.281 4.65ZM16.348 29.045H16.343C13.993 29.044 11.686 28.425 9.671 27.257L9.197 26.977L3.981 28.327L5.353 23.231L5.042 22.738C3.737 20.644 3.049 18.236 3.05 15.757C3.053 8.543 8.934 2.663 16.153 2.663C19.664 2.664 22.979 3.988 25.488 6.499C27.998 9.01 29.321 12.327 29.32 15.981C29.316 23.195 23.435 29.075 16.348 29.075V29.045ZM23.397 19.324C23.019 19.135 21.168 18.223 20.818 18.09C20.467 17.957 20.209 17.891 19.951 18.269C19.693 18.647 18.975 19.503 18.745 19.761C18.515 20.019 18.285 20.053 17.907 19.864C17.529 19.675 16.295 19.266 14.839 17.973C13.705 16.966 12.932 15.721 12.702 15.343C12.472 14.965 12.677 14.752 12.866 14.564C13.037 14.394 13.244 14.121 13.433 13.891C13.622 13.661 13.688 13.487 13.821 13.229C13.954 12.971 13.888 12.741 13.793 12.552C13.698 12.363 12.929 10.51 12.612 9.754C12.302 9.018 11.987 9.119 11.752 9.107C11.527 9.096 11.269 9.094 11.011 9.094C10.753 9.094 10.347 9.189 9.997 9.567C9.646 9.945 8.679 10.857 8.679 12.71C8.679 14.563 10.031 16.36 10.22 16.618C10.409 16.876 12.929 20.821 16.848 22.442C17.705 22.816 18.374 23.038 18.895 23.203C19.754 23.476 20.54 23.437 21.161 23.341C21.857 23.234 23.397 22.476 23.714 21.642C24.031 20.808 24.031 20.107 23.936 19.952C23.841 19.797 23.583 19.702 23.205 19.513L23.397 19.324Z" fill="white"/>
      </svg>
      <span class="jetwide-whatsapp-text">Instant WhatsApp Chat</span>
    `;
    
    document.body.appendChild(button);
    
    // Add pulse animation on load
    setTimeout(() => {
      button.classList.add('pulse');
      setTimeout(() => button.classList.remove('pulse'), 1000);
    }, 1000);
    
    // Pulse every 10 seconds
    setInterval(() => {
      button.classList.add('pulse');
      setTimeout(() => button.classList.remove('pulse'), 1000);
    }, 10000);
  }

  /**
   * Generate WhatsApp URL
   */
  function getWhatsAppURL(message, packageName = '') {
    const fullMessage = packageName ? message + packageName : message;
    const encodedMessage = encodeURIComponent(fullMessage);
    return `https://wa.me/${WHATSAPP_CONFIG.phone}?text=${encodedMessage}`;
  }

  /**
   * Add WhatsApp buttons to package cards
   */
  function addPackageButtons() {
    // Safari package cards
    const packageCards = document.querySelectorAll('.destination-card, .special-card, .themed-card, .package-card, .international-card');
    
    packageCards.forEach(card => {
      // Skip if button already exists
      if (card.querySelector('.jetwide-wa-btn')) {
        return;
      }

      const packageName = card.querySelector('h3, h4, .destination-location, .special-title, .themed-card-title, .package-title, .international-card-title')?.textContent || 'this package';
      
      const button = document.createElement('a');
      button.href = getWhatsAppURL(WHATSAPP_CONFIG.messages.safari, packageName);
      button.target = '_blank';
      button.rel = 'noopener noreferrer';
      button.className = 'jetwide-wa-btn jetwide-wa-safari';
      button.setAttribute('aria-label', `Book ${packageName} on WhatsApp`);
      button.innerHTML = `
        <svg width="20" height="20" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M27.281 4.65C24.318 1.686 20.361 0.028 16.148 0C7.467 0 0.391 7.075 0.387 15.757C0.386 18.542 1.096 21.257 2.445 23.655L0.262 32L8.845 29.862C11.15 31.091 13.723 31.738 16.342 31.739H16.348C25.029 31.739 32.105 24.663 32.109 15.982C32.11 11.776 30.455 7.827 27.491 4.862L27.281 4.65ZM16.348 29.045H16.343C13.993 29.044 11.686 28.425 9.671 27.257L9.197 26.977L3.981 28.327L5.353 23.231L5.042 22.738C3.737 20.644 3.049 18.236 3.05 15.757C3.053 8.543 8.934 2.663 16.153 2.663C19.664 2.664 22.979 3.988 25.488 6.499C27.998 9.01 29.321 12.327 29.32 15.981C29.316 23.195 23.435 29.075 16.348 29.075V29.045ZM23.397 19.324C23.019 19.135 21.168 18.223 20.818 18.09C20.467 17.957 20.209 17.891 19.951 18.269C19.693 18.647 18.975 19.503 18.745 19.761C18.515 20.019 18.285 20.053 17.907 19.864C17.529 19.675 16.295 19.266 14.839 17.973C13.705 16.966 12.932 15.721 12.702 15.343C12.472 14.965 12.677 14.752 12.866 14.564C13.037 14.394 13.244 14.121 13.433 13.891C13.622 13.661 13.688 13.487 13.821 13.229C13.954 12.971 13.888 12.741 13.793 12.552C13.698 12.363 12.929 10.51 12.612 9.754C12.302 9.018 11.987 9.119 11.752 9.107C11.527 9.096 11.269 9.094 11.011 9.094C10.753 9.094 10.347 9.189 9.997 9.567C9.646 9.945 8.679 10.857 8.679 12.71C8.679 14.563 10.031 16.36 10.22 16.618C10.409 16.876 12.929 20.821 16.848 22.442C17.705 22.816 18.374 23.038 18.895 23.203C19.754 23.476 20.54 23.437 21.161 23.341C21.857 23.234 23.397 22.476 23.714 21.642C24.031 20.808 24.031 20.107 23.936 19.952C23.841 19.797 23.583 19.702 23.205 19.513L23.397 19.324Z" fill="currentColor"/>
        </svg>
        Book This Safari on WhatsApp
      `;
      
      // Insert button in appropriate location
      const info = card.querySelector('.destination-info, .special-content, .themed-card-content, .package-content, .international-card-overlay');
      if (info) {
        info.appendChild(button);
      } else {
        card.appendChild(button);
      }
    });
  }

  /**
   * Add page-specific WhatsApp CTAs
   */
  function addPageSpecificCTAs() {
    const pageType = detectPageType();
    
    switch(pageType) {
      case 'visa':
        addVisaCTA();
        break;
      case 'job':
        addJobCTA();
        break;
      case 'airline':
        addAirlineCTA();
        break;
      case 'carhire':
        addCarHireCTA();
        break;
      case 'contact':
        addContactCTA();
        break;
      case 'blog':
        addBlogCTA();
        break;
    }
  }

  /**
   * Detect current page type
   */
  function detectPageType() {
    const path = window.location.pathname.toLowerCase();
    
    if (path.includes('visa')) return 'visa';
    if (path.includes('job')) return 'job';
    if (path.includes('airline') || path.includes('airport')) return 'airline';
    if (path.includes('car-hire') || path.includes('carhire')) return 'carhire';
    if (path.includes('contact')) return 'contact';
    if (path.includes('blog')) return 'blog';
    
    return 'home';
  }

  /**
   * Add Visa Services CTA
   */
  function addVisaCTA() {
    const heroSection = document.querySelector('.visa-hero, .hero-section');
    if (!heroSection || heroSection.querySelector('.jetwide-wa-cta')) return;

    const cta = document.createElement('a');
    cta.href = getWhatsAppURL(WHATSAPP_CONFIG.messages.visa);
    cta.target = '_blank';
    cta.rel = 'noopener noreferrer';
    cta.className = 'jetwide-wa-cta jetwide-wa-visa';
    cta.setAttribute('aria-label', 'Talk to a Visa Expert on WhatsApp');
    cta.innerHTML = `
      <svg width="24" height="24" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M27.281 4.65C24.318 1.686 20.361 0.028 16.148 0C7.467 0 0.391 7.075 0.387 15.757C0.386 18.542 1.096 21.257 2.445 23.655L0.262 32L8.845 29.862C11.15 31.091 13.723 31.738 16.342 31.739H16.348C25.029 31.739 32.105 24.663 32.109 15.982C32.11 11.776 30.455 7.827 27.491 4.862L27.281 4.65ZM16.348 29.045H16.343C13.993 29.044 11.686 28.425 9.671 27.257L9.197 26.977L3.981 28.327L5.353 23.231L5.042 22.738C3.737 20.644 3.049 18.236 3.05 15.757C3.053 8.543 8.934 2.663 16.153 2.663C19.664 2.664 22.979 3.988 25.488 6.499C27.998 9.01 29.321 12.327 29.32 15.981C29.316 23.195 23.435 29.075 16.348 29.075V29.045ZM23.397 19.324C23.019 19.135 21.168 18.223 20.818 18.09C20.467 17.957 20.209 17.891 19.951 18.269C19.693 18.647 18.975 19.503 18.745 19.761C18.515 20.019 18.285 20.053 17.907 19.864C17.529 19.675 16.295 19.266 14.839 17.973C13.705 16.966 12.932 15.721 12.702 15.343C12.472 14.965 12.677 14.752 12.866 14.564C13.037 14.394 13.244 14.121 13.433 13.891C13.622 13.661 13.688 13.487 13.821 13.229C13.954 12.971 13.888 12.741 13.793 12.552C13.698 12.363 12.929 10.51 12.612 9.754C12.302 9.018 11.987 9.119 11.752 9.107C11.527 9.096 11.269 9.094 11.011 9.094C10.753 9.094 10.347 9.189 9.997 9.567C9.646 9.945 8.679 10.857 8.679 12.71C8.679 14.563 10.031 16.36 10.22 16.618C10.409 16.876 12.929 20.821 16.848 22.442C17.705 22.816 18.374 23.038 18.895 23.203C19.754 23.476 20.54 23.437 21.161 23.341C21.857 23.234 23.397 22.476 23.714 21.642C24.031 20.808 24.031 20.107 23.936 19.952C23.841 19.797 23.583 19.702 23.205 19.513L23.397 19.324Z" fill="currentColor"/>
      </svg>
      Talk to a Visa Expert on WhatsApp
    `;

    const heroContent = heroSection.querySelector('.hero-content, .visa-hero-content, .hero-buttons');
    if (heroContent) {
      heroContent.appendChild(cta);
    }
  }

  /**
   * Add Job Placement CTA
   */
  function addJobCTA() {
    const heroSection = document.querySelector('.job-hero, .hero-section');
    if (!heroSection || heroSection.querySelector('.jetwide-wa-cta')) return;

    const cta = document.createElement('a');
    cta.href = getWhatsAppURL(WHATSAPP_CONFIG.messages.job);
    cta.target = '_blank';
    cta.rel = 'noopener noreferrer';
    cta.className = 'jetwide-wa-cta jetwide-wa-job';
    cta.setAttribute('aria-label', 'Apply on WhatsApp');
    cta.innerHTML = `
      <svg width="24" height="24" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M27.281 4.65C24.318 1.686 20.361 0.028 16.148 0C7.467 0 0.391 7.075 0.387 15.757C0.386 18.542 1.096 21.257 2.445 23.655L0.262 32L8.845 29.862C11.15 31.091 13.723 31.738 16.342 31.739H16.348C25.029 31.739 32.105 24.663 32.109 15.982C32.11 11.776 30.455 7.827 27.491 4.862L27.281 4.65ZM16.348 29.045H16.343C13.993 29.044 11.686 28.425 9.671 27.257L9.197 26.977L3.981 28.327L5.353 23.231L5.042 22.738C3.737 20.644 3.049 18.236 3.05 15.757C3.053 8.543 8.934 2.663 16.153 2.663C19.664 2.664 22.979 3.988 25.488 6.499C27.998 9.01 29.321 12.327 29.32 15.981C29.316 23.195 23.435 29.075 16.348 29.075V29.045ZM23.397 19.324C23.019 19.135 21.168 18.223 20.818 18.09C20.467 17.957 20.209 17.891 19.951 18.269C19.693 18.647 18.975 19.503 18.745 19.761C18.515 20.019 18.285 20.053 17.907 19.864C17.529 19.675 16.295 19.266 14.839 17.973C13.705 16.966 12.932 15.721 12.702 15.343C12.472 14.965 12.677 14.752 12.866 14.564C13.037 14.394 13.244 14.121 13.433 13.891C13.622 13.661 13.688 13.487 13.821 13.229C13.954 12.971 13.888 12.741 13.793 12.552C13.698 12.363 12.929 10.51 12.612 9.754C12.302 9.018 11.987 9.119 11.752 9.107C11.527 9.096 11.269 9.094 11.011 9.094C10.753 9.094 10.347 9.189 9.997 9.567C9.646 9.945 8.679 10.857 8.679 12.71C8.679 14.563 10.031 16.36 10.22 16.618C10.409 16.876 12.929 20.821 16.848 22.442C17.705 22.816 18.374 23.038 18.895 23.203C19.754 23.476 20.54 23.437 21.161 23.341C21.857 23.234 23.397 22.476 23.714 21.642C24.031 20.808 24.031 20.107 23.936 19.952C23.841 19.797 23.583 19.702 23.205 19.513L23.397 19.324Z" fill="currentColor"/>
      </svg>
      Get Started – WhatsApp Our Recruitment Team
    `;

    const heroContent = heroSection.querySelector('.hero-content, .job-hero-content, .hero-buttons');
    if (heroContent) {
      heroContent.appendChild(cta);
    }
  }

  /**
   * Add Airline Booking CTA
   */
  function addAirlineCTA() {
    const heroSection = document.querySelector('.flight-booking-hero, .hero-section');
    if (!heroSection || heroSection.querySelector('.jetwide-wa-cta')) return;

    const cta = document.createElement('a');
    cta.href = getWhatsAppURL(WHATSAPP_CONFIG.messages.airline);
    cta.target = '_blank';
    cta.rel = 'noopener noreferrer';
    cta.className = 'jetwide-wa-cta jetwide-wa-airline';
    cta.setAttribute('aria-label', 'Book Flight on WhatsApp');
    cta.innerHTML = `
      <svg width="24" height="24" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M27.281 4.65C24.318 1.686 20.361 0.028 16.148 0C7.467 0 0.391 7.075 0.387 15.757C0.386 18.542 1.096 21.257 2.445 23.655L0.262 32L8.845 29.862C11.15 31.091 13.723 31.738 16.342 31.739H16.348C25.029 31.739 32.105 24.663 32.109 15.982C32.11 11.776 30.455 7.827 27.491 4.862L27.281 4.65ZM16.348 29.045H16.343C13.993 29.044 11.686 28.425 9.671 27.257L9.197 26.977L3.981 28.327L5.353 23.231L5.042 22.738C3.737 20.644 3.049 18.236 3.05 15.757C3.053 8.543 8.934 2.663 16.153 2.663C19.664 2.664 22.979 3.988 25.488 6.499C27.998 9.01 29.321 12.327 29.32 15.981C29.316 23.195 23.435 29.075 16.348 29.075V29.045ZM23.397 19.324C23.019 19.135 21.168 18.223 20.818 18.09C20.467 17.957 20.209 17.891 19.951 18.269C19.693 18.647 18.975 19.503 18.745 19.761C18.515 20.019 18.285 20.053 17.907 19.864C17.529 19.675 16.295 19.266 14.839 17.973C13.705 16.966 12.932 15.721 12.702 15.343C12.472 14.965 12.677 14.752 12.866 14.564C13.037 14.394 13.244 14.121 13.433 13.891C13.622 13.661 13.688 13.487 13.821 13.229C13.954 12.971 13.888 12.741 13.793 12.552C13.698 12.363 12.929 10.51 12.612 9.754C12.302 9.018 11.987 9.119 11.752 9.107C11.527 9.096 11.269 9.094 11.011 9.094C10.753 9.094 10.347 9.189 9.997 9.567C9.646 9.945 8.679 10.857 8.679 12.71C8.679 14.563 10.031 16.36 10.22 16.618C10.409 16.876 12.929 20.821 16.848 22.442C17.705 22.816 18.374 23.038 18.895 23.203C19.754 23.476 20.54 23.437 21.161 23.341C21.857 23.234 23.397 22.476 23.714 21.642C24.031 20.808 24.031 20.107 23.936 19.952C23.841 19.797 23.583 19.702 23.205 19.513L23.397 19.324Z" fill="currentColor"/>
      </svg>
      Book Flight on WhatsApp
    `;

    const heroContent = heroSection.querySelector('.hero-content, .flight-hero-content, .hero-buttons');
    if (heroContent) {
      heroContent.appendChild(cta);
    }
  }

  /**
   * Add Car Hire CTA
   */
  function addCarHireCTA() {
    const heroSection = document.querySelector('.car-hire-hero, .hero-section');
    if (!heroSection || heroSection.querySelector('.jetwide-wa-cta')) return;

    const cta = document.createElement('a');
    cta.href = getWhatsAppURL(WHATSAPP_CONFIG.messages.carhire);
    cta.target = '_blank';
    cta.rel = 'noopener noreferrer';
    cta.className = 'jetwide-wa-cta jetwide-wa-carhire';
    cta.setAttribute('aria-label', 'Hire a Car via WhatsApp');
    cta.innerHTML = `
      <svg width="24" height="24" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M27.281 4.65C24.318 1.686 20.361 0.028 16.148 0C7.467 0 0.391 7.075 0.387 15.757C0.386 18.542 1.096 21.257 2.445 23.655L0.262 32L8.845 29.862C11.15 31.091 13.723 31.738 16.342 31.739H16.348C25.029 31.739 32.105 24.663 32.109 15.982C32.11 11.776 30.455 7.827 27.491 4.862L27.281 4.65ZM16.348 29.045H16.343C13.993 29.044 11.686 28.425 9.671 27.257L9.197 26.977L3.981 28.327L5.353 23.231L5.042 22.738C3.737 20.644 3.049 18.236 3.05 15.757C3.053 8.543 8.934 2.663 16.153 2.663C19.664 2.664 22.979 3.988 25.488 6.499C27.998 9.01 29.321 12.327 29.32 15.981C29.316 23.195 23.435 29.075 16.348 29.075V29.045ZM23.397 19.324C23.019 19.135 21.168 18.223 20.818 18.09C20.467 17.957 20.209 17.891 19.951 18.269C19.693 18.647 18.975 19.503 18.745 19.761C18.515 20.019 18.285 20.053 17.907 19.864C17.529 19.675 16.295 19.266 14.839 17.973C13.705 16.966 12.932 15.721 12.702 15.343C12.472 14.965 12.677 14.752 12.866 14.564C13.037 14.394 13.244 14.121 13.433 13.891C13.622 13.661 13.688 13.487 13.821 13.229C13.954 12.971 13.888 12.741 13.793 12.552C13.698 12.363 12.929 10.51 12.612 9.754C12.302 9.018 11.987 9.119 11.752 9.107C11.527 9.096 11.269 9.094 11.011 9.094C10.753 9.094 10.347 9.189 9.997 9.567C9.646 9.945 8.679 10.857 8.679 12.71C8.679 14.563 10.031 16.36 10.22 16.618C10.409 16.876 12.929 20.821 16.848 22.442C17.705 22.816 18.374 23.038 18.895 23.203C19.754 23.476 20.54 23.437 21.161 23.341C21.857 23.234 23.397 22.476 23.714 21.642C24.031 20.808 24.031 20.107 23.936 19.952C23.841 19.797 23.583 19.702 23.205 19.513L23.397 19.324Z" fill="currentColor"/>
      </svg>
      Hire a Car via WhatsApp
    `;

    const heroContent = heroSection.querySelector('.hero-content, .car-hire-hero-content, .hero-buttons');
    if (heroContent) {
      heroContent.appendChild(cta);
    }
  }

  /**
   * Add Contact Page CTA
   */
  function addContactCTA() {
    const contactSection = document.querySelector('.contact-section, .hero-section');
    if (!contactSection || contactSection.querySelector('.jetwide-wa-cta')) return;

    const cta = document.createElement('a');
    cta.href = getWhatsAppURL(WHATSAPP_CONFIG.messages.contact);
    cta.target = '_blank';
    cta.rel = 'noopener noreferrer';
    cta.className = 'jetwide-wa-cta jetwide-wa-contact';
    cta.setAttribute('aria-label', 'WhatsApp Jetwide');
    cta.innerHTML = `
      <svg width="24" height="24" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M27.281 4.65C24.318 1.686 20.361 0.028 16.148 0C7.467 0 0.391 7.075 0.387 15.757C0.386 18.542 1.096 21.257 2.445 23.655L0.262 32L8.845 29.862C11.15 31.091 13.723 31.738 16.342 31.739H16.348C25.029 31.739 32.105 24.663 32.109 15.982C32.11 11.776 30.455 7.827 27.491 4.862L27.281 4.65ZM16.348 29.045H16.343C13.993 29.044 11.686 28.425 9.671 27.257L9.197 26.977L3.981 28.327L5.353 23.231L5.042 22.738C3.737 20.644 3.049 18.236 3.05 15.757C3.053 8.543 8.934 2.663 16.153 2.663C19.664 2.664 22.979 3.988 25.488 6.499C27.998 9.01 29.321 12.327 29.32 15.981C29.316 23.195 23.435 29.075 16.348 29.075V29.045ZM23.397 19.324C23.019 19.135 21.168 18.223 20.818 18.09C20.467 17.957 20.209 17.891 19.951 18.269C19.693 18.647 18.975 19.503 18.745 19.761C18.515 20.019 18.285 20.053 17.907 19.864C17.529 19.675 16.295 19.266 14.839 17.973C13.705 16.966 12.932 15.721 12.702 15.343C12.472 14.965 12.677 14.752 12.866 14.564C13.037 14.394 13.244 14.121 13.433 13.891C13.622 13.661 13.688 13.487 13.821 13.229C13.954 12.971 13.888 12.741 13.793 12.552C13.698 12.363 12.929 10.51 12.612 9.754C12.302 9.018 11.987 9.119 11.752 9.107C11.527 9.096 11.269 9.094 11.011 9.094C10.753 9.094 10.347 9.189 9.997 9.567C9.646 9.945 8.679 10.857 8.679 12.71C8.679 14.563 10.031 16.36 10.22 16.618C10.409 16.876 12.929 20.821 16.848 22.442C17.705 22.816 18.374 23.038 18.895 23.203C19.754 23.476 20.54 23.437 21.161 23.341C21.857 23.234 23.397 22.476 23.714 21.642C24.031 20.808 24.031 20.107 23.936 19.952C23.841 19.797 23.583 19.702 23.205 19.513L23.397 19.324Z" fill="currentColor"/>
      </svg>
      WhatsApp Us Now
    `;

    const contactContent = contactSection.querySelector('.contact-content, .hero-content, .contact-methods');
    if (contactContent) {
      contactContent.appendChild(cta);
    }
  }

  /**
   * Add Blog Page CTA
   */
  function addBlogCTA() {
    const blogSection = document.querySelector('.blog-hero, .hero-section');
    if (!blogSection || blogSection.querySelector('.jetwide-wa-cta')) return;

    const cta = document.createElement('a');
    cta.href = getWhatsAppURL(WHATSAPP_CONFIG.messages.blog);
    cta.target = '_blank';
    cta.rel = 'noopener noreferrer';
    cta.className = 'jetwide-wa-cta jetwide-wa-blog';
    cta.setAttribute('aria-label', 'Ask Us on WhatsApp');
    cta.innerHTML = `
      <svg width="24" height="24" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M27.281 4.65C24.318 1.686 20.361 0.028 16.148 0C7.467 0 0.391 7.075 0.387 15.757C0.386 18.542 1.096 21.257 2.445 23.655L0.262 32L8.845 29.862C11.15 31.091 13.723 31.738 16.342 31.739H16.348C25.029 31.739 32.105 24.663 32.109 15.982C32.11 11.776 30.455 7.827 27.491 4.862L27.281 4.65ZM16.348 29.045H16.343C13.993 29.044 11.686 28.425 9.671 27.257L9.197 26.977L3.981 28.327L5.353 23.231L5.042 22.738C3.737 20.644 3.049 18.236 3.05 15.757C3.053 8.543 8.934 2.663 16.153 2.663C19.664 2.664 22.979 3.988 25.488 6.499C27.998 9.01 29.321 12.327 29.32 15.981C29.316 23.195 23.435 29.075 16.348 29.075V29.045ZM23.397 19.324C23.019 19.135 21.168 18.223 20.818 18.09C20.467 17.957 20.209 17.891 19.951 18.269C19.693 18.647 18.975 19.503 18.745 19.761C18.515 20.019 18.285 20.053 17.907 19.864C17.529 19.675 16.295 19.266 14.839 17.973C13.705 16.966 12.932 15.721 12.702 15.343C12.472 14.965 12.677 14.752 12.866 14.564C13.037 14.394 13.244 14.121 13.433 13.891C13.622 13.661 13.688 13.487 13.821 13.229C13.954 12.971 13.888 12.741 13.793 12.552C13.698 12.363 12.929 10.51 12.612 9.754C12.302 9.018 11.987 9.119 11.752 9.107C11.527 9.096 11.269 9.094 11.011 9.094C10.753 9.094 10.347 9.189 9.997 9.567C9.646 9.945 8.679 10.857 8.679 12.71C8.679 14.563 10.031 16.36 10.22 16.618C10.409 16.876 12.929 20.821 16.848 22.442C17.705 22.816 18.374 23.038 18.895 23.203C19.754 23.476 20.54 23.437 21.161 23.341C21.857 23.234 23.397 22.476 23.714 21.642C24.031 20.808 24.031 20.107 23.936 19.952C23.841 19.797 23.583 19.702 23.205 19.513L23.397 19.324Z" fill="currentColor"/>
      </svg>
      Ask Us on WhatsApp
    `;

    const blogContent = blogSection.querySelector('.blog-hero-content, .hero-content, .hero-buttons');
    if (blogContent) {
      blogContent.appendChild(cta);
    }
  }

  /**
   * Initialize WhatsApp integration
   */
  function init() {
    // Wait for DOM to be ready
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', init);
      return;
    }

    // Create floating button
    createFloatingButton();

    // Add package buttons
    setTimeout(addPackageButtons, 500);

    // Add page-specific CTAs
    setTimeout(addPageSpecificCTAs, 800);

    // Re-add buttons if content changes
    const observer = new MutationObserver(() => {
      addPackageButtons();
    });

    observer.observe(document.body, {
      childList: true,
      subtree: true
    });

    console.log('✅ Jetwide WhatsApp Integration loaded');
  }

  // Start initialization
  init();
})();
