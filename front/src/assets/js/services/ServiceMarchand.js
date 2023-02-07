import {ServiceXhr} from "./ServiceXhr";
import {ServiceHub} from "./ServiceHub";

export const ServiceMarchand = {
    getAll: async () => {
        let hosts = await ServiceHub.getAllHosts();
        let lesMarchands = [];
        for(let host of await hosts.json()) {
            let lesMarchandsDeLInstance = await ServiceXhr.callWithoutAuthWithoutBody(`https://${host.ip}:${process.env.VUE_APP_PORT_API}/api/marchands`, "GET");
            for(let unMarchandDeLInstance of await lesMarchandsDeLInstance.json()) {
                unMarchandDeLInstance.instance = host;
                lesMarchands.push(unMarchandDeLInstance);
            }
        }

        return lesMarchands;
    }
}