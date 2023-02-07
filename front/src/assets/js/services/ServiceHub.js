import {ServiceXhr} from "./ServiceXhr";

export const ServiceHub = {
    getAllHosts: async () => {
        return ServiceXhr.callWithoutAuthWithoutBody(`http://${process.env.VUE_APP_IP_API}:${process.env.VUE_APP_PORT_API}/api/hub/host/all`, "GET");
    }
}