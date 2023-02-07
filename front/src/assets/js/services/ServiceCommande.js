import {ServiceXhr} from "./ServiceXhr";
import {ServiceHub} from "@/assets/js/services/ServiceHub";
import {ServiceUtilisateur} from "@/assets/js/services/ServiceUtilisateurs";

export const ServiceCommande = {
    save: async (lesProduits) => {
        let hosts = await ServiceHub.getAllHosts();

        let newProduits = [];
        for(let produit of lesProduits) {
            newProduits.push({idProduit: produit.id, idInstance: produit.marchand.instance.id, qte: produit.qte});
        }

        let info = await (await ServiceUtilisateur.getInfo()).json();

        for(let host of await hosts.json()) {
            const data = JSON.stringify({utilisateur: info.utilisateur, produits: newProduits});
            await ServiceXhr.callWithoutAuth(`https://${host.ip}:${process.env.VUE_APP_PORT_API}/api/commandes/save`, data, "POST");
        }

    }
}