import {ServiceXhr} from "./ServiceXhr";

export const ServiceUtilisateur = {
    login: async (email, password) => {
        const data = JSON.stringify({email: email, password: password});
        return ServiceXhr.callWithoutAuth(`https://${process.env.VUE_APP_IP_API}:${process.env.VUE_APP_PORT_API}/api/users/login`, data, "POST");
    },

    register: async (email, password, type) => {
        const data = JSON.stringify({email: email, password: password, type: type});
        return ServiceXhr.callWithoutAuth(`https://${process.env.VUE_APP_IP_API}:${process.env.VUE_APP_PORT_API}/api/users/register`, data, "POST");
    },

    getInfo: async () => {
        return ServiceXhr.callWithAuthNoBody(`https://${process.env.VUE_APP_IP_API}:${process.env.VUE_APP_PORT_API}/api/users/info`, "GET");
    }
}