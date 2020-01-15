/*
 * MIT License
 *
 * Copyright (c) 2020 Yurii Dubinka
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

insert into users(id, name, email) values(1, 'Tom', 'tom@email.com');
insert into users(id, name, email) values(2, 'Tim', 'tim@email.com');
insert into users(id, name, email) values(3, 'Ann', 'ann@email.com');
insert into phones(id, number, owner) values (1, '555 555 001', 1);
insert into phones(id, number, owner) values (2, '555 555 011', 1);
insert into phones(id, number, owner) values (3, '555 555 002', 2);
insert into phones(id, number, owner) values (4, '555 555 022', 2);
insert into phones(id, number, owner) values (5, '555 555 003', 3);
insert into phones(id, number, owner) values (6, '555 555 033', 3);