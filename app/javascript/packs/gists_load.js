$(document).on('turbolinks:load', () => {
  gistsLoad();

  $(document).on('ajax:success', (event) => {
    gistsLoad();
  })
})

function gistsLoad() {
  $('.gist').each(function() {
    gistGet(this);
  });
}

function gistGet(element) {
  fetch(`https://api.github.com/gists/${gistId(element)}`)
    .then((response) => {
      return response.json();
    })
    .then((gist) => {
      return Promise.all([gistFiles(gist), gist]);
    })
    .then(([files, gist]) => {
      gistShow(files, gist, element);
    });
}

function gistFiles(gist) {
  let files = [];

  for(let file in gist.files) files.push(file);

  return files;
}

function gistShow(files, gist, element) {
  let html = '';

  files.forEach(file => {
    html += `<a href=${gistLink(element)}>${file}</a>`;
    html += `<p>${gist.files[file].content}</p>`;
  })

  element.innerHTML = html;
  element.classList.remove('gist');
}

function gistLink(element) {
  return element.getElementsByTagName('a')[0].href;
}

function gistId(element) {
  return element
           .getElementsByTagName('a')[0]
           .href.split('/')
           .slice(-1)
           .toString();
}
