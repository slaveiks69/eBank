const postData = async (url = '', data = {}) => {
  // Формируем запрос
  const response = await fetch(url, {
    // Метод, если не указывать, будет использоваться GET
    method: 'POST',
    // Заголовок запроса
    headers: {
      'Content-Type': 'application/json'
    },
    // Данные
    body: JSON.stringify(data)
  });
  return response.json();
};

$("#passport").mask("** ** ******")

$(".btn-add").click(function () {
  $(".popup").removeClass("popup-close");
  document.querySelector('.popup').src = "add/";
  document.getElementById('export').classList.remove("popup-close");
});

window.person_to_html = function person_to_html(person, index = top.document.querySelector("#table").children.length) {
  let i = top.document.createElement('div');
  i.classList.add("export-item");
  i.innerHTML =
    "<i>" + person.id + ' | ' + person.passportSerial + ' | ' + person.lastName[0] + person.firstName[0] + person.patronymic[0] + "</i>";
  let a = top.document.createElement('a');
  a.classList.add('x');
  a.innerHTML = "x";
  a.setAttribute("id",index);
  a.addEventListener('click', function () {
    delete_export_item(index);
  });
  i.appendChild(a);
  top.document.getElementById('table').appendChild(i);
}

function delete_export_item(index) {
  top.document.querySelector("#table").children[index].remove();
  get_add().splice(index,1);

  top.document.getElementById('table').innerHTML = '';
  if (get_add() != null)
    get_add().forEach((person, index) => person_to_html(person, index));

  localStorage.setItem("add", JSON.stringify(get_add()));
}

$(".btn-export").click(function () {
  let classes = document.getElementById('export').classList;

  if (classes.contains("popup-close")) {
    top.document.getElementById('table').innerHTML = '';
    add = JSON.parse(localStorage.getItem("add"));
    if (add != null)
      add.forEach((person, index) => person_to_html(person, index));
    classes.remove("popup-close");
  }
  else
    classes.add("popup-close");
});

$(".btn-at").click(function () {
  document.getElementById('at').classList.remove("popup-close");
});

$(".close-authors").click(function () {
  document.getElementById('at').classList.add("popup-close");
});

$(".drag").draggable({});

$(".btn-team").click(function () {
  let window_db = document.querySelector(".team");

  if (window_db.classList.contains("popup-close"))
    window_db.classList.remove("popup-close");
  else
    window_db.classList.add("popup-close");
});

$(".db_refresh").click(function () {
  w2ui['grid'].reload();
});

$(".btn-db").click(function () {
  let window_db = document.querySelector(".window_db");

  if (window_db.classList.contains("popup-close"))
    window_db.classList.remove("popup-close");
  else
    window_db.classList.add("popup-close");
});

$(".btn-monitoring").click(function () {
  let window = document.querySelector(".monitoring");

  if (window.classList.contains("popup-close"))
    window.classList.remove("popup-close");
  else
    window.classList.add("popup-close");
});

//window.frames[2].add

function get_add() {
  if (window.frames[2].add != undefined)
    return window.frames[2].add;
  else if (add != undefined)
    return add;
  return [];
}


$(document).ready(function () {
  $(".export").click(function () {
    let data1 = get_add();

    postData('http://localhost:1111/export', { data: data1 })
      .then((data) => {
        if (data.export == "okay") {
          clear_export();
        }
      });
  });
  $(".clear").click(function () {
    clear_export();
  });
});

function clear_export() {
  document.getElementById('table').innerHTML = '';
  let add = [];
  localStorage.setItem("add", JSON.stringify(add));
  frames[2].window.add.length = 0;
}