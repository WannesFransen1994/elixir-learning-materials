import {btn, para} from './selector.js'

var showSecret = false;

btn.addEventListener('click', toggleSecretState);
updateSecretParagraph();

function toggleSecretState() {
    showSecret = !showSecret;
    updateSecretParagraph();
    updateSecretButton()
}

function updateSecretButton() {
    if (showSecret) {
        btn.textContent = 'Hide the Secret';
    } else {
        btn.textContent = 'Show the Secret';
    }
}

function updateSecretParagraph() {
    if (showSecret) {
        para.style.display = 'block';
    } else {
        para.style.display = 'none';
    }
}