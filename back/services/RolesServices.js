import {database} from "../db/initDb.js";

export const RolesServices = {
    getIdByLibelle: async (libelle) => {
        let connexion = database.createConnexionInstance();
        let sql = `select id from Roles where libelle = "${libelle}"`;
        let result = await connexion.awaitQuery(sql);
        database.closeConnexion(connexion);
        return result;
    },
}