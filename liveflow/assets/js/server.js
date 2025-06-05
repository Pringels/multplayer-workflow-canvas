import * as Components from "../svelte/**/*.svelte";
import { getRender } from "live_svelte";

console.log("XXX", Components);

export const render = getRender(Components);
