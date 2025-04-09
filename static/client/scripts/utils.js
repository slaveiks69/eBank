const getData = async (url = '') => {
    let static_uri = window.uri
    const response = await fetch(static_uri+url, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        },
    });
    return response.json();
};

const postData = async (url = '', data = {}) => {
    let static_uri = window.uri
    const response = await fetch(static_uri+url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    });
    return response.json();
  };