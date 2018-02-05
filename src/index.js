import { sceneJSON } from '../output/Main';

import { doPoints } from './canvas';

const points = JSON.parse(sceneJSON);

doPoints(points);