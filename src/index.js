import { interpolateLine } from '../output/line';

console.log('hello world')
console.log('hello world2')
console.log(
  interpolateLine({x:0, y:0})
                 ({x:10, y:5})
                 (10));