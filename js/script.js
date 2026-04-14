document.addEventListener("DOMContentLoaded", function () {
  const menuToggle = document.getElementById("menu-toggle");
  const nav = document.getElementById("nav");

  if (menuToggle && nav) {
    menuToggle.addEventListener("click", function () {
      nav.classList.toggle("open");
    });
  }

  const contactForm = document.getElementById("contactForm");

  if (contactForm) {
    contactForm.addEventListener("submit", function (e) {
      e.preventDefault();

      const name = document.getElementById("name");
      const email = document.getElementById("email");
      const phone = document.getElementById("phone");
      const propertyType = document.getElementById("propertyType");
      const servicesNeeded = document.getElementById("servicesNeeded");
      const message = document.getElementById("message");
      const formStatus = document.getElementById("formStatus");

      let isValid = true;

      clearError(name);
      clearError(email);
      clearError(phone);
      clearError(propertyType);
      clearError(servicesNeeded);
      clearError(message);

      if (name.value.trim() === "") {
        showError(name, "Please enter your name.");
        isValid = false;
      }

      if (email.value.trim() === "") {
        showError(email, "Please enter your email.");
        isValid = false;
      } else if (!validateEmail(email.value.trim())) {
        showError(email, "Please enter a valid email address.");
        isValid = false;
      }

      if (phone.value.trim() === "") {
        showError(phone, "Please enter your phone number.");
        isValid = false;
      }

      if (propertyType.value.trim() === "") {
        showError(propertyType, "Please select a property type.");
        isValid = false;
      }

      if (servicesNeeded.value.trim() === "") {
        showError(servicesNeeded, "Please specify the services needed.");
        isValid = false;
      }

      if (message.value.trim() === "") {
        showError(message, "Please enter your message.");
        isValid = false;
      }

      if (isValid) {
        formStatus.style.color = "green";
        formStatus.textContent = "Form submitted successfully! Connect this form to your backend or email service.";
        contactForm.reset();
      } else {
        formStatus.style.color = "#c62828";
        formStatus.textContent = "Please correct the highlighted errors and try again.";
      }
    });
  }

  function showError(input, message) {
    const formGroup = input.parentElement;
    const error = formGroup.querySelector(".error-message");
    if (error) {
      error.textContent = message;
    }
    input.style.borderColor = "#c62828";
  }

  function clearError(input) {
    const formGroup = input.parentElement;
    const error = formGroup.querySelector(".error-message");
    if (error) {
      error.textContent = "";
    }
    input.style.borderColor = "#cfd8cc";
  }

  function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }
});
