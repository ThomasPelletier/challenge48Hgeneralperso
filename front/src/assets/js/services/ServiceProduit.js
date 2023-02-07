import {ServiceXhr} from "@/assets/js/services/ServiceXhr";

export const ServiceProduit = {
    getAllProduitByMarchand: async (marchand) => {
        let produits = await ServiceXhr.callWithoutAuthWithoutBody(`http://${marchand.instance.ip}:${process.env.VUE_APP_PORT_API}/api/produits/filtre/marchand/${marchand.id}`, "GET");
        let produitsFinaux = [];
        for(let produit of await produits.json()) {
            produit.marchand = marchand;
            produitsFinaux.push(produit);
        }

        return produitsFinaux;
    }
}