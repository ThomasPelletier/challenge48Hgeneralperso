export const ServiceXhr = {
    callWithoutAuth: async (url, data, methode) => {
        return await fetch(url, {
            method: methode.toUpperCase(),
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: data,
        })
    },

    callWithoutAuthWithoutBody: async (url, methode) => {
        return await fetch(url, {
            method: methode.toUpperCase(),
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
        })
    },

    callWithAuthNoBody: async (url, methode) => {
        return await fetch(url, {
            method: methode.toUpperCase(),
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + localStorage.getItem("token")
            },
        });
    },
}