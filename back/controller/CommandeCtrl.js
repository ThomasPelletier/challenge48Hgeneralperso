import Joi from "joi";
import {HubServices} from "../services/HubServices.js";
import {CommandeServices} from "../services/CommandeServices.js";

export const CommandeCtrl = {
    save: async (ctx) => {
        try {
            const getAllMarchandValidationSchema = new Joi.object({
                produits: Joi.array().items(
                    Joi.object({
                        idProduit: Joi.number().required(),
                        idInstance: Joi.number().required()
                    })
                ).required(),
                utilisateur: Joi.object({
                   id: Joi.number().required(),
                   instance: Joi.number().required()
                }).required()
            });

            const params = ctx.request.body;
            const { error, value } = getAllMarchandValidationSchema.validate(params);
            if(error) throw new Error(error);


            let currentIdInstance = (await HubServices.getByIp(process.env.ip))["id"];

            let produits = params.produits.filter(produit => produit.idInstance === currentIdInstance);

            if(produits.length > 0) {
                let commandeId = await CommandeServices.createCommande(params.utilisateur.id, params.utilisateur.instance);
                await CommandeServices.addProduitsToCommande(produits, commandeId);
            }

            ctx.noContent();
        } catch (e) {
            ctx.badRequest({message: e.message})
        }
    }
}